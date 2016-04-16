require 'rails_helper'

RSpec.describe V1::SessionsController, :type => :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/v1/sessions').to route_to('v1/sessions#create')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/sessions').to route_to('v1/sessions#destroy')
    end

  end
end