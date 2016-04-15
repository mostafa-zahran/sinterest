class UpdateFoundPlaylist
  include Interactor

  before do
    context.fail! if context.playlist.blank? || context.playlist_params.blank?
  end

  def call
    unless context.playlist.update(context.playlist_params)
      context.fail!
    end
  end
end