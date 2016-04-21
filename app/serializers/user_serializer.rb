class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :user_token

  def filter(keys)
    if meta && meta[:include_token]
      keys
    else
      keys - [:user_token]
    end
  end

  has_many :tracks
  has_many :playlists
end