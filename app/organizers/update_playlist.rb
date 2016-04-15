class UpdatePlaylist
  include Interactor::Organizer

  organize GetPlaylistById, UpdateFoundPlaylist
end