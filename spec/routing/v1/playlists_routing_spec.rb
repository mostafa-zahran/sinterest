require 'rails_helper'

RSpec.describe V1::PlaylistsController, :type => :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/v1/playlists').to route_to('v1/playlists#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/playlists/1').to route_to('v1/playlists#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/playlists').to route_to('v1/playlists#create')
    end

    it 'routes to #update' do
      expect(put: '/v1/playlists/1').to route_to('v1/playlists#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/playlists/1').to route_to('v1/playlists#destroy', id: '1')
    end

  end
end