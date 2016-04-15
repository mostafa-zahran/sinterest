class DestroyPlaylist
  include Interactor::Organizer

  organize GetPlaylistById, DestroyFoundPlaylist
end