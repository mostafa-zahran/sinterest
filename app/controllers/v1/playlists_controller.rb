module V1
  class PlaylistsController < ApplicationController
    load_and_authorize_resource

    def index
      result = GetAllPlaylists.call
      render json: result.success? ? result.playlists : []
    end

    def show
      result = GetPlaylistById.call(id: params[:id])
      render json: result.success? ? result.playlist : []
    end

    def create
      result = CreatePlaylist.call(playlist_params: playlist_params, user_id: current_user.id)
      if result.success?
        render json: result.playlist, status: :created, location: v1_playlist_url(result.playlist)
      else
        render json: result.playlist.errors, status: :unprocessable_entity
      end
    end

    def update
      result = UpdatePlaylist.call(id: params[:id], playlist_params: playlist_params)
      if result.success?
        render json: result.playlist
      else
        render json: result.playlist.errors, status: :unprocessable_entity
      end
    end

    def destroy
      result = DestroyPlaylist.call(id: params[:id])
      render status: result.success? ? :no_content : :unprocessable_entity
    end

    private

    def playlist_params
      params.permit(:name, track_ids: [])
    end
  end
end