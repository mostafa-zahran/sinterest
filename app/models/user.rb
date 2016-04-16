# This is user model
class User < ApplicationRecord
  has_many :tracks, dependent: :nullify
  has_many :playlists, dependent: :nullify

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email
  validates_length_of :name, minimum: 4

  has_secure_password

  # Assign an Token key on create
  before_validation on: :create do |user|
    user.user_token = user.generate_user_token
  end

  # Generate a unique Token key
  def generate_user_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(user_token: token)
    end
  end
end
