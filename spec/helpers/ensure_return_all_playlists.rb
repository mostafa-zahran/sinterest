module EnsureReturnAllPlaylists
  def ensure_return_all_playlists
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    playlist_names = body['playlists'].map { |playlist| playlist['name'] }
    expect(playlist_names).to match_array(['Admin Playlist', 'Normal Playlist'])
    playlist_user_ids = body['playlists'].map { |playlist| playlist['user_id'] }
    expect(playlist_user_ids).not_to be_empty
  end
end