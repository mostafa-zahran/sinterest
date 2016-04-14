# This is user model
class User < ApplicationRecord
  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email
  validates_length_of :name, minimum: 4

  # Assign an API key on create
  before_validation on: :create do |user|
    user.user_token = user.generate_user_token
  end

  # Generate a unique API key
  def generate_user_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(user_token: token)
    end
  end
end
