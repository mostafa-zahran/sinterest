require 'rails_helper'

RSpec.shared_examples 'ensure_return_all_playlists' do
  it 'read all playlists' do
    get '/v1/playlists', nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(token)}
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    playlist_names = body['playlists'].map { |playlist| playlist['name'] }
    expect(playlist_names).to match_array(['Admin Playlist', 'Normal Playlist'])
    playlist_user_ids = body['playlists'].map { |playlist| playlist['user_id'] }
    expect(playlist_user_ids).not_to be_empty
  end
end

RSpec.describe 'Playlist', type: :request do
  let!(:admin) { FactoryGirl.create :user }
  let!(:normal) { FactoryGirl.create :user, name: 'Mona Ali', email: 'mona.ali@gmail.com', admin: false, password: '123456789', password_confirmation: '123456789' }
  let!(:admin_playlist) { FactoryGirl.create :playlist, name: 'Admin Playlist', user_id: admin.id }
  let!(:normal_playlist) { FactoryGirl.create :playlist, name: 'Normal Playlist', user_id: normal.id }
  let!(:admin_tracks) { (1..3).map { FactoryGirl.create(:track, name: 'My Dog', user_id: admin.id, sound_track: Rails.root.join('spec/dog_puppy.wav').open).id } }
  let!(:normal_tracks) { (1..3).map { FactoryGirl.create(:track, name: 'My Dog', user_id: normal.id, sound_track: Rails.root.join('spec/dog_puppy.wav').open).id } }

  describe 'GET /v1/playlists' do
    context 'Guest Session' do
      it_behaves_like 'ensure_return_all_playlists' do
        let(:token) { nil }
      end
    end

    context 'Admin session' do
      it_behaves_like 'ensure_return_all_playlists' do
        let(:token) { admin.user_token }
      end
    end

    context 'Normal session' do
      it_behaves_like 'ensure_return_all_playlists' do
        let(:token) { normal.user_token }
      end
    end
  end

  describe 'GET /v1/playlists/:id' do
    context 'Guest Session' do
      it 'returns the specified playlist' do
        get "/v1/playlists/#{admin_playlist.id}"
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['playlist']['name']) == admin_playlist.name
        expect(body['playlist']['user_id']) == admin_playlist.user_id
      end
    end
    context 'Admin Session' do
      it 'returns the specified playlist' do
        get "/v1/playlists/#{admin_playlist.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['playlist']['name']) == admin_playlist.name
        expect(body['playlist']['user_id']) == admin_playlist.user_id
      end
    end
    context 'Normal Session' do
      it 'returns the specified playlist' do
        get "/v1/playlists/#{admin_playlist.id}", nil, headers: {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['playlist']['name']) == admin_playlist.name
        expect(body['playlist']['user_id']) == admin_playlist.user_id
      end
    end
  end

  describe 'POST /v1/playlists' do
    let!(:new_playlist) { {name: 'My New Playlist'} }
    context 'Guest Session' do
      it 'can not create playlist' do
        post '/v1/playlists', new_playlist, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'creates the specified playlist' do
        new_playlist[:track_ids] = admin_tracks
        post '/v1/playlists', new_playlist, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 201
        body = JSON.parse(response.body)
        expect(body['playlist']['name']) == new_playlist[:name]
        expect(body['playlist']['user_id']) == new_playlist[:user_id]
      end
    end
    context 'Normal Session' do
      it 'creates the specified playlist' do
        new_playlist[:track_ids] = normal_tracks
        post '/v1/playlists', new_playlist, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 201
        expect(body['playlist']['name']) == new_playlist[:name]
        expect(body['playlist']['user_id']) == new_playlist[:user_id]
      end
    end
  end

  describe 'PUT /v1/playlists/:id' do
    let!(:updated_playlist) { {name: 'Doggy playlist'} }

    context 'Guest Session' do
      it 'can not update any playlist' do
        put "/v1/playlists/#{admin_playlist.id}", params: updated_playlist.to_json, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'can update any playlist' do
        updated_playlist[:track_ids] = normal_tracks
        put "/v1/playlists/#{normal_playlist.id}", params: updated_playlist.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['playlist']['name']) == 'Doggy playlist'
      end
    end
    context 'Normal Session' do
      it 'can update his playlist' do
        updated_playlist[:track_ids] = normal_tracks
        put "/v1/playlists/#{normal_playlist.id}", params: updated_playlist.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['playlist']['name']) == 'Doggy playlist'
      end
      it 'can not update anyone else' do
        updated_playlist[:track_ids] = normal_tracks
        put "/v1/playlists/#{admin_playlist.id}", params: updated_playlist.to_json, headers: {'Content-Type': 'application/json', authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /v1/playlists/:id' do
    context 'Guest Session' do
      it 'deletes the specified playlist' do
        delete "/v1/playlists/#{admin_playlist.id}"
        expect(response.status).to eq 401
      end
    end
    context 'Admin Session' do
      it 'deletes the specified playlist' do
        delete "/v1/playlists/#{admin_playlist.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 204
        delete "/v1/playlists/#{normal_playlist.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)}
        expect(response.status).to eq 204
      end
    end
    context 'Normal Session' do
      it 'deletes the specified playlist' do
        delete "/v1/playlists/#{normal_playlist.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 204
        delete "/v1/playlists/#{admin_playlist.id}", {}, {authorization: ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)}
        expect(response.status).to eq 401
      end
    end
  end
end
