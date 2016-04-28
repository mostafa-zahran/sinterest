FactoryGirl.define do
  factory :track do
    sound_track Rails.root.join('spec/dog_puppy.wav').open

    factory :admin_track, class: Track do
      name 'Admin Dog'
      association :user, factory: :admin_user
    end

    factory :normal_track, class: Track do
      name 'Normal Dog'
      association :user, factory: :normal_user
    end
  end
end
