class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :user_token

  def user_token
    object.user_token if scope && scope[:include_token]
  end

  has_many :tracks
  has_many :playlists
end