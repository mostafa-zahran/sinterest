require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Playlist, type: :model do
  it { is_expected.to respond_to(:name, :user_id, :tracks) }
  it do
    is_expected.to validate_presence_of(:name)
    is_expected.to validate_presence_of(:user_id)
  end
  it { is_expected.to validate_length_of(:name).is_at_least(4) }

  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }
    context 'when is an admin' do
      let(:user) { FactoryGirl.create :user }
      it { is_expected.to be_able_to(:manage, Playlist.new) }
    end
    context 'when is a normal' do
      let(:user) { FactoryGirl.create :user, name: 'Mona Ali', email: 'mona.ali@gmail.com', admin: false, password: '123456789', password_confirmation: '123456789'}
      let(:playlist) { FactoryGirl.create :playlist, name: 'My Playlist2', user_id: user.id}
      it { is_expected.to be_able_to(:index, [Playlist.new, playlist]) }
      it { is_expected.to be_able_to(:show, [Playlist.new, playlist]) }
      it { is_expected.to be_able_to(:update, playlist, user_id: user.id) }
      it { is_expected.not_to be_able_to(:update, Playlist.new) }
      it { is_expected.to be_able_to(:destroy, playlist, user_id: user.id) }
      it { is_expected.not_to be_able_to(:destroy, Playlist.new) }
      it { is_expected.to be_able_to(:create, Playlist.new) }
    end
    context 'when is a guest' do
      it { is_expected.to be_able_to(:index, Playlist.new) }
      it { is_expected.to be_able_to(:show, Playlist.new) }
      it { is_expected.not_to be_able_to(:update, Playlist.new) }
      it { is_expected.not_to be_able_to(:destroy, Playlist.new) }
      it { is_expected.not_to be_able_to(:create, Playlist.new) }
    end
  end
end
