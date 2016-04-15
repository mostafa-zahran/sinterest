class Track < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :playlists
  mount_uploader :sound_track, TrackUploader

  validates_presence_of :name, :user_id, :sound_track
  validates_length_of :name, minimum: 4

  before_destroy { playlists.clear }
end