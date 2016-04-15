require 'rails_helper'
require 'helpers/ensure_return_all_tracks'
include EnsureReturnAllTracks

RSpec.describe 'Track', type: :request do
  before do
    @admin = FactoryGirl.create :user
    @normal = FactoryGirl.create :user, name: 'Mona Ali', email: 'mona.ali@gmail.com', admin: false
    @admin_track = FactoryGirl.create :track, name: 'My Dog', user_id: @admin.id, sound_track: Rails.root.join('spec/dog_puppy.wav').open
    @normal_track = FactoryGirl.create :track, name: 'My Dog', user_id: @normal.id, sound_track: Rails.root.join('spec/dog_puppy.wav').open
  end

  describe 'GET /v1/tracks' do
    context 'Guest Session' do
      it 'read all tracks' do
        get '/v1/tracks'
        ensure_return_all_tracks
      end
    end

    context 'Admin session' do
      it 'read all tracks' do
        get '/v1/tracks', nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        ensure_return_all_tracks
      end
    end

    context 'Normal session' do
      it 'read all tracks' do
        get '/v1/tracks', nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        ensure_return_all_tracks
      end
    end
  end

  describe 'GET /v1/tracks/:id' do
    context 'Guest Session' do
      it 'returns the specified track' do
        get "/v1/tracks/#{@admin_track.id}"
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == @admin_track.name
        expect(body['track']['user_id']) == @admin_track.user_id
      end
    end
    context 'Admin Session' do
      it 'returns the specified track' do
        get "/v1/tracks/#{@admin_track.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == @admin_track.name
        expect(body['track']['user_id']) == @admin_track.user_id
      end
    end
    context 'Normal Session' do
      it 'returns the specified track' do
        get "/v1/tracks/#{@admin_track.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == @admin_track.name
        expect(body['track']['user_id']) == @admin_track.user_id
      end
    end
  end

  describe 'POST /v1/tracks' do
    before do
      @new_track = {name: 'My Dog', sound_track: Rack::Test::UploadedFile.new(Rails.root.join('spec/dog_puppy.wav').open)}
    end
    context 'Guest Session' do
      it 'can not create track' do
        post '/v1/tracks', @new_track, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'creates the specified track' do
        post '/v1/tracks', @new_track, { authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 201
        body = JSON.parse(response.body)
        expect(body['track']['name']) == @new_track[:name]
        expect(body['track']['user_id']) == @new_track[:user_id]
      end
    end
    context 'Normal Session' do
      it 'creates the specified track' do
        post '/v1/tracks', @new_track, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 201
        expect(body['track']['name']) == @new_track[:name]
        expect(body['track']['user_id']) == @new_track[:user_id]
      end
    end
  end

  describe 'PUT /v1/tracks/:id' do
    before do
      @updated_track = {name: 'My new dog'}
    end
    context 'Guest Session' do
      it 'can not update any track' do
        put "/v1/tracks/#{@admin_track.id}", params: @updated_track.to_json, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'can update any track' do
        put "/v1/tracks/#{@normal_track.id}", params: @updated_track.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == 'My new dog'
      end
    end
    context 'Normal Session' do
      it 'can update his track' do
        put "/v1/tracks/#{@normal_track.id}", params: @updated_track.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == 'My new dog'
      end
      it 'can not update anyone else' do
        put "/v1/tracks/#{@admin_track.id}", params: @updated_track.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /v1/tracks/:id' do
    context 'Guest Session' do
      it 'deletes the specified track' do
        delete "/v1/tracks/#{@admin_track.id}"
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'deletes the specified track' do
        delete "/v1/tracks/#{@admin_track.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 204
        delete "/v1/tracks/#{@normal_track.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@admin.user_token)}
        expect(response.status).to eq 204
      end
    end
    context 'Normal Session' do
      it 'deletes the specified track' do
        delete "/v1/tracks/#{@normal_track.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 204
        delete "/v1/tracks/#{@admin_track.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(@normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end
end
