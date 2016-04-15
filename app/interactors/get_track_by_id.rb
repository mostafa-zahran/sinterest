class GetTrackById
  include Interactor

  before do
    context.fail! if context.id.blank? || (@track = Track.find_by_id(context.id)).blank?
  end

  def call
    context.track = @track
  end
end