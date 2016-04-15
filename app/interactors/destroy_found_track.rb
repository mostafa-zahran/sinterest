class DestroyFoundTrack
  include Interactor

  before do
    context.fail! if context.track.blank?
  end

  def call
    unless context.track.destroy
      context.fail!
    end
  end
end