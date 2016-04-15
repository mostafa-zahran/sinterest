class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :user_token
  has_many :tracks
  has_many :playlists
end
