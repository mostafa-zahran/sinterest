class DestroyTrack
  include Interactor::Organizer

  organize GetTrackById, DestroyFoundTrack
end