class CreatePlaylist
  include Interactor

  before do
    context.fail! if context.playlist_params.blank? || context.user_id.blank?
  end

  def call
    playlist = Playlist.new(context.playlist_params)
    playlist.user_id = context.user_id
    if playlist.save
      context.playlist = playlist
    else
      context.playlist = playlist
      context.fail!
    end
  end
end