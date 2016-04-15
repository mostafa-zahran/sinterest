class GetPlaylistById
  include Interactor

  before do
    context.fail! if context.id.blank? || (@playlist = Playlist.find_by_id(context.id)).blank?
  end

  def call
    context.playlist = @playlist
  end
end