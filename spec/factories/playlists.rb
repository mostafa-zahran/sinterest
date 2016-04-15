FactoryGirl.define do
  factory :playlist do
    name 'My Playlist'
    user
    after(:create) do |playlist, _evaluator|
      create_list(:track, 5, playlists: [playlist], user_id: playlist.user_id)
    end
  end
end
