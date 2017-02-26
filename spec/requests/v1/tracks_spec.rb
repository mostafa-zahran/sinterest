require 'rails_helper'

RSpec.shared_examples 'ensure_return_all_tracks' do
  it 'read all tracks' do
    get '/v1/tracks', nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(token)}
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    track_names = body['tracks'].map { |track| track['name'] }
    expect(track_names).to match_array(['Admin Dog', 'Normal Dog', 'Track1', 'Track2'])
    track_user_ids = body['tracks'].map { |track| track['user_id'] }
    expect(track_user_ids).not_to be_empty
  end
end

RSpec.describe 'Track', type: :request do
  let!(:admin) { FactoryGirl.create :admin_user }
  let!(:normal) { FactoryGirl.create :normal_user }
  let!(:admin_track) { FactoryGirl.create :admin_track, user_id: admin.id }
  let!(:normal_track) { FactoryGirl.create :normal_track, user_id: normal.id }

  describe 'GET /v1/tracks' do
    context 'Guest Session' do
      it_behaves_like 'ensure_return_all_tracks' do
        let(:token) { nil }
      end
    end

    context 'Admin session' do
      it_behaves_like 'ensure_return_all_tracks' do
        let(:token) { admin.user_token }
      end
    end

    context 'Normal session' do
      it_behaves_like 'ensure_return_all_tracks' do
        let(:token) { normal.user_token }
      end
    end
  end

  describe 'GET /v1/tracks/:id' do
    context 'Guest Session' do
      it 'returns the specified track' do
        get "/v1/tracks/#{admin_track.id}"
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == admin_track.name
        expect(body['track']['user_id']) == admin_track.user_id
      end
    end
    context 'Admin Session' do
      it 'returns the specified track' do
        get "/v1/tracks/#{admin_track.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == admin_track.name
        expect(body['track']['user_id']) == admin_track.user_id
      end
    end
    context 'Normal Session' do
      it 'returns the specified track' do
        get "/v1/tracks/#{admin_track.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == admin_track.name
        expect(body['track']['user_id']) == admin_track.user_id
      end
    end
  end

  describe 'POST /v1/tracks' do
    let!(:new_track) { {name: 'My Dog', sound_track: Rack::Test::UploadedFile.new(Rails.root.join('spec/dog_puppy.wav').open)} }
    context 'Guest Session' do
      it 'can not create track' do
        post '/v1/tracks', new_track, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'creates the specified track' do
        post '/v1/tracks', new_track, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 201
        body = JSON.parse(response.body)
        expect(body['track']['name']) == new_track[:name]
        expect(body['track']['user_id']) == new_track[:user_id]
      end
    end
    context 'Normal Session' do
      it 'creates the specified track' do
        post '/v1/tracks', new_track, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 201
        expect(body['track']['name']) == new_track[:name]
        expect(body['track']['user_id']) == new_track[:user_id]
      end
    end
  end

  describe 'PUT /v1/tracks/:id' do
    let!(:updated_track) { {name: 'My new dog'} }
    context 'Guest Session' do
      it 'can not update any track' do
        put "/v1/tracks/#{admin_track.id}", params: updated_track.to_json, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'can update any track' do
        put "/v1/tracks/#{normal_track.id}", params: updated_track.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == 'My new dog'
      end
    end
    context 'Normal Session' do
      it 'can update his track' do
        put "/v1/tracks/#{normal_track.id}", params: updated_track.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['track']['name']) == 'My new dog'
      end
      it 'can not update anyone else' do
        put "/v1/tracks/#{admin_track.id}", params: updated_track.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /v1/tracks/:id' do
    context 'Guest Session' do
      it 'deletes the specified track' do
        delete "/v1/tracks/#{admin_track.id}"
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'deletes the specified track' do
        delete "/v1/tracks/#{admin_track.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 204
        delete "/v1/tracks/#{normal_track.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 204
      end
    end
    context 'Normal Session' do
      it 'deletes the specified track' do
        delete "/v1/tracks/#{normal_track.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 204
        delete "/v1/tracks/#{admin_track.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end
end
