class UpdateFoundTrack
  include Interactor

  before do
    context.fail! if context.track.blank? || context.track_params.blank?
  end

  def call
    unless context.track.update(context.track_params)
      context.fail!
    end
  end
end