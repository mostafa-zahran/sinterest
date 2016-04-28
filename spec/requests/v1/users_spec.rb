require 'rails_helper'

RSpec.shared_examples 'ensure_return_all_users' do
  it 'read all users' do
    get '/v1/users', nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(token)}
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    user_names = body['users'].map { |user| user['name'] }
    expect(user_names).to match_array(['Mostafa Kamel', 'Mona Ali'])
    user_emails = body['users'].map { |user| user['email'] }
    expect(user_emails).to match_array(%w(mostafa.k.zahran@gmail.com mona.ali@gmail.com))
    user_token = body['users'].map { |user| user['user_token'] }
    expect(user_token).not_to be_empty
  end
end

RSpec.describe 'User', type: :request do
  let!(:admin) { FactoryGirl.create :admin_user }
  let!(:normal) { FactoryGirl.create :normal_user }

  describe 'GET /v1/users' do
    context 'Guest Session' do
      it_behaves_like 'ensure_return_all_users' do
        let(:token) { nil }
      end
    end

    context 'Admin session' do
      it_behaves_like 'ensure_return_all_users' do
        let(:token) { admin.user_token }
      end
    end

    context 'Normal session' do
      it_behaves_like 'ensure_return_all_users' do
        let(:token) { normal.user_token }
      end
    end
  end

  describe 'GET /v1/users/:id' do
    context 'Guest Session' do
      it 'returns the specified user' do
        get "/v1/users/#{admin.id}"
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == admin.name
        expect(body['user']['email']) == admin.email
        expect(body['user']['user_token']).to be_blank
      end
    end
    context 'Admin Session' do
      it 'returns the specified user' do
        get "/v1/users/#{admin.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == admin.name
        expect(body['user']['email']) == admin.email
        expect(body['user']['user_token']).to be_blank
      end
    end
    context 'Normal Session' do
      it 'returns the specified user' do
        get "/v1/users/#{admin.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == admin.name
        expect(body['user']['email']) == admin.email
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
        post '/v1/users', params: @new_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 201
        body = JSON.parse(response.body)
        expect(body['user']['name']) == @new_user[:name]
        expect(body['user']['email']) == @new_user[:email]
        expect(body['user']['user_token']).to be_blank
      end
    end
    context 'Normal Session' do
      it 'can not create another user' do
        post '/v1/users', params: @new_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
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
        put "/v1/users/#{normal.id}", params: @updated_user.to_json, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'can update any user' do
        put "/v1/users/#{normal.id}", params: @updated_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == 'Mostafa Zahran'
      end
    end
    context 'Normal Session' do
      it 'can update himself user' do
        put "/v1/users/#{normal.id}", params: @updated_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['name']) == 'Mostafa Zahran'
      end
      it 'can not update anyone else' do
        put "/v1/users/#{admin.id}", params: @updated_user.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /v1/users/:id' do
    context 'Guest Session' do
      it 'deletes the specified user' do
        delete "/v1/users/#{normal.id}"
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'deletes the specified user' do
        delete "/v1/users/#{normal.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 204
        delete "/v1/users/#{admin.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 204
      end
    end
    context 'Normal Session' do
      it 'deletes the specified user' do
        delete "/v1/users/#{normal.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 204
        delete "/v1/users/#{admin.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end
end
