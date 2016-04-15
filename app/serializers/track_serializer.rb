class TrackSerializer < ActiveModel::Serializer
  attributes :id, :name, :sound_track
  belongs_to :user_id
  has_many :playlists
end
