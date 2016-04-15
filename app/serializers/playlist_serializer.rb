class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name
  belongs_to :user_id
  has_many :tracks
end
