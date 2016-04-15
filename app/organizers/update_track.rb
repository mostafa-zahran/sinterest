class UpdateTrack
  include Interactor::Organizer

  organize GetTrackById, UpdateFoundTrack
end