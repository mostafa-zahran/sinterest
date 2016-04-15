FactoryGirl.define do
  factory :track do
    name 'My Dog'
    user
    sound_track Rails.root.join('spec/dog_puppy.wav').open
  end
end
