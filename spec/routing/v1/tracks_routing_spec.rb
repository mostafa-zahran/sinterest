require 'rails_helper'

RSpec.describe V1::TracksController, :type => :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/v1/tracks').to route_to('v1/tracks#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/tracks/1').to route_to('v1/tracks#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/tracks').to route_to('v1/tracks#create')
    end

    it 'routes to #update' do
      expect(put: '/v1/tracks/1').to route_to('v1/tracks#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/tracks/1').to route_to('v1/tracks#destroy', id: '1')
    end

  end
end