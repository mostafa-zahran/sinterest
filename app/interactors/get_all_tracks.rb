class GetAllTracks
  include Interactor

  def call
    context.tracks = Track.all
  end
end