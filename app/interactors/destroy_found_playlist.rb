class DestroyFoundPlaylist
  include Interactor

  before do
    context.fail! if context.playlist.blank?
  end

  def call
    unless context.playlist.destroy
      context.fail!
    end
  end
end