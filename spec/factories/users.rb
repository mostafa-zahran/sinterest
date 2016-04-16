FactoryGirl.define do
  factory :user do
    name 'Mostafa Kamel'
    email 'mostafa.k.zahran@gmail.com'
    admin true
    password '123456789'
    password_confirmation '123456789'
    before(:create) { |user| user.user_token = user.generate_user_token }
  end
end
