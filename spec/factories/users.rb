FactoryGirl.define do
  factory :user do

    password '123456789'
    password_confirmation '123456789'
    before(:create) { |user| user.user_token = user.generate_user_token }

    factory :admin_user, class: User do
      name 'Mostafa Kamel'
      email 'mostafa.k.zahran@gmail.com'
      admin true
    end

    factory :normal_user, class: User do
      name 'Mona Ali'
      email 'mona.ali@gmail.com'
      admin false
    end
  end
end
