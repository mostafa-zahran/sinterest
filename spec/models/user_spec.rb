require 'rails_helper'
require 'cancan/matchers'
RSpec.describe User, type: :model do
  it { should respond_to(:name, :email, :admin?, :user_token, :tracks, :playlists) }
  it do
    should validate_presence_of(:name)
    should validate_presence_of(:email)
  end
  it { should validate_length_of(:name).is_at_least(4) }
  it do
    should validate_uniqueness_of(:name)
    should validate_uniqueness_of(:email)
  end

  describe 'abilities' do
    subject(:ability){ Ability.new(user) }
    let(:user){ nil }
    context 'when is an admin' do
      let(:user){ FactoryGirl.create :user }
      it{ should be_able_to(:manage, User.new) }
    end
    context 'when is a normal' do
      let(:user){ FactoryGirl.create :user, name: 'Mona Ali', email: 'mona.ali@gmail.com', admin: false, password: '123456789', password_confirmation: '123456789' }
      it{ should be_able_to(:index, [User.new, user]) }
      it{ should be_able_to(:show, [User.new, user]) }
      it{ should be_able_to(:update, user, id: user.id) }
      it{ should_not be_able_to(:update, User.new) }
      it{ should be_able_to(:destroy, user, id: user.id) }
      it{ should_not be_able_to(:destroy, User.new) }
      it{ should_not be_able_to(:create, User.new) }
    end
    context 'when is a guest' do
      it{ should be_able_to(:index, User.new) }
      it{ should be_able_to(:show, User.new) }
      it{ should_not be_able_to(:update, User.new) }
      it{ should_not be_able_to(:destroy, User.new) }
      it{ should be_able_to(:create, User.new) }
    end
  end
end
