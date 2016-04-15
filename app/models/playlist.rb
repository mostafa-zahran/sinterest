class Playlist < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tracks

  validates_presence_of :name, :user_id
  validates_length_of :name, minimum: 4

  before_destroy { tracks.clear }
end