FactoryGirl.define do
  factory :playlist do
    after(:create) do |playlist, _evaluator|
      create_list(:admin_track, 5, playlists: [playlist], user_id: playlist.user_id)
    end

    factory :admin_playlist, class: Playlist do
      name 'Admin Playlist'
      association :user, factory: :admin_user
    end

    factory :normal_playlist, class: Playlist do
      name 'Normal Playlist'
      association :user, factory: :normal_user
    end
  end
end
