require 'rails_helper'
require 'helpers/ensure_return_all_user'
include EnsureReturnAllUsers

RSpec.describe 'User', type: :request do
  before do
    @admin = FactoryGirl.create :user
    @normal = FactoryGirl.create :user, name: 'Mona Ali', email: 'mona.ali@gmail.com', admin: false, password: '123456789', password_confirmation: '123456789'
  end

  describe 'GET /v1/users' do
    context 'Guest Session' do
      it 'read all users' do
        get '/v1/users'
        ensure_return_all_users
      end
    end

    context 'Admin session' do
      it 'read all users' do
        get '/v1/users', nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        ensure_return_all_users
      end
    end

    context 'Normal session' do
      it 'read all users' do
        get '/v1/users', nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        ensure_return_all_users
      end
    end
  end

  describe 'GET /v1/users/:id' do
    context 'Guest Session' do
      it 'returns the specified user' do
        get "/v1/users/#{@admin.id}"
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == @admin.name
        expect(body['user']['email']) == @admin.email
        expect(body['user']['user_token']).to be_blank
      end
    end
    context 'Admin Session' do
      it 'returns the specified user' do
        get "/v1/users/#{@admin.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == @admin.name
        expect(body['user']['email']) == @admin.email
        expect(body['user']['user_token']).to be_blank
      end
    end
    context 'Normal Session' do
      it 'returns the specified user' do
        get "/v1/users/#{@admin.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == @admin.name
        expect(body['user']['email']) == @admin.email
        expect(body['user']['user_token']).to be_blank
      end
    end
  end

  describe 'POST /v1/users' do
    before do
      @new_user = {name: 'Maha Awaad', email: 'maha.awaad@gmail.com', password: '123456789', password_confirmation: '123456789'}
    end
    context 'Guest Session' do
      it 'creates the specified user' do
        post '/v1/users', params: @new_user.to_json, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 201
        body = JSON.parse(response.body)
        expect(body['user']['name']) == @new_user[:name]
        expect(body['user']['email']) == @new_user[:email]
        expect(body['user']['user_token']).to be_blank
      end
    end
    context 'Admin Session' do
      it 'creates the specified user' do
        post '/v1/users', params: @new_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 201
        body = JSON.parse(response.body)
        expect(body['user']['name']) == @new_user[:name]
        expect(body['user']['email']) == @new_user[:email]
        expect(body['user']['user_token']).to be_blank
      end
    end
    context 'Normal Session' do
      it 'can not create another user' do
        post '/v1/users', params: @new_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PUT /v1/users/:id' do
    before do
      @updated_user = {name: 'Mostafa Zahran'}
    end
    context 'Guest Session' do
      it 'can not update any user' do
        put "/v1/users/#{@normal.id}", params: @updated_user.to_json, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'can update any user' do
        put "/v1/users/#{@normal.id}", params: @updated_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == 'Mostafa Zahran'
      end
    end
    context 'Normal Session' do
      it 'can update himself user' do
        put "/v1/users/#{@normal.id}", params: @updated_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == 'Mostafa Zahran'
      end
      it 'can not update anyone else' do
        put "/v1/users/#{@admin.id}", params: @updated_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /v1/users/:id' do
    context 'Guest Session' do
      it 'deletes the specified user' do
        delete "/v1/users/#{@normal.id}"
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'deletes the specified user' do
        delete "/v1/users/#{@normal.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 204
        delete "/v1/users/#{@admin.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 204
      end
    end
    context 'Normal Session' do
      it 'deletes the specified user' do
        delete "/v1/users/#{@normal.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 204
        delete "/v1/users/#{@admin.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end
end
