module EnsureReturnAllTracks
  def ensure_return_all_tracks
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    track_names = body['tracks'].map { |track| track['name'] }
    expect(track_names).to match_array(['My Dog', 'My Dog'])
    track_user_ids = body['tracks'].map { |track| track['user_id'] }
    expect(track_user_ids).not_to be_empty
  end
end