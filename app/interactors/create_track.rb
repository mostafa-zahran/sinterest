class CreateTrack
  include Interactor

  before do
    context.fail! if context.track_params.blank? || context.user_id.blank?
  end

  def call
    track = Track.new(context.track_params)
    track.user_id = context.user_id
    track.sound_track = context.sound_track
    if track.save
      context.track = track
    else
      context.track = track
      context.fail!
    end
  end
end