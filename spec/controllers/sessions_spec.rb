require 'rails_helper'

RSpec.describe V1::SessionsController, type: :controller do
  let!(:admin) { FactoryGirl.create :user }
  let!(:normal) { FactoryGirl.create :user, name: 'Mona Ali', email: 'mona.ali@gmail.com', admin: false, password: '123456789', password_confirmation: '123456789' }
  let!(:new_user) { {password: '123456789', email: 'mona.ali@gmail.com'} }

  describe 'POST /v1/sessions' do
    context 'Guest Session' do
      it 'can sign in' do
        post :create, new_user, headers: {'Content-Type': 'application/json'}
        expect(response.status).to eq 200
        body = JSON.parse(response.body)
        expect(body['user']['email']).to eq new_user[:email]
        expect(body['user']['user_token']).not_to be_empty
      end
    end
    context 'Admin Session' do
      it 'can not sign in again' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)
        post :create, new_user
        expect(response.status).to eq 422
      end
    end
    context 'Normal Session' do
      it 'can not sign in again' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)
        post :create, new_user
        expect(response.status).to eq 422
      end
    end
  end

  describe 'DELETE /v1/sessions' do
    context 'Guest Session' do
      it 'can not sign out' do
        delete :destroy
        expect(response.status).to eq 422
      end
    end
    context 'Admin Session' do
      it 'can sign out' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(admin.user_token)
        delete :destroy
        expect(response.status).to eq 204
      end
    end
    context 'Normal Session' do
      it 'can sign out' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(normal.user_token)
        delete :destroy
        expect(response.status).to eq 204
      end
    end
  end
end
