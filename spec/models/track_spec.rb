require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Track, type: :model do
  it { is_expected.to respond_to(:name, :user_id, :sound_track, :playlists) }
  it do
    is_expected.to validate_presence_of(:name)
    is_expected.to validate_presence_of(:sound_track)
    is_expected.to validate_presence_of(:user_id)
  end
  it { is_expected.to validate_length_of(:name).is_at_least(4) }

  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }
    context 'when is an admin' do
      let(:user) { FactoryGirl.create :user }
      it { is_expected.to be_able_to(:manage, Track.new) }
    end
    context 'when is a normal' do
      let(:user) { FactoryGirl.create :user, name: 'Mona Ali', email: 'mona.ali@gmail.com', admin: false, password: '123456789', password_confirmation: '123456789' }
      let(:track) { FactoryGirl.create :track, name: 'My Track', user_id: user.id, sound_track: Rails.root.join('spec/dog_puppy.wav').open }
      it { is_expected.to be_able_to(:index, [Track.new, track]) }
      it { is_expected.to be_able_to(:show, [Track.new, track]) }
      it { is_expected.to be_able_to(:update, track, user_id: user.id) }
      it { is_expected.not_to be_able_to(:update, Track.new) }
      it { is_expected.to be_able_to(:destroy, track, user_id: user.id) }
      it { is_expected.not_to be_able_to(:destroy, Track.new) }
      it { is_expected.to be_able_to(:create, Track.new) }
    end
    context 'when is a guest' do
      it { is_expected.to be_able_to(:index, Track.new) }
      it { is_expected.to be_able_to(:show, Track.new) }
      it { is_expected.not_to be_able_to(:update, Track.new) }
      it { is_expected.not_to be_able_to(:destroy, Track.new) }
      it { is_expected.not_to be_able_to(:create, Track.new) }
    end
  end
end
