class GetAllPlaylists
  include Interactor

  def call
    context.playlists = Playlist.all
  end
end