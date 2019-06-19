class Api::V1::TracksController < ApplicationController

  def index
    tracks = current_user.tracks
    # render json: tracks
  end

  def get_recently_played
    recent_tracks = current_user.get_recently_played
    # render json: recent_tracks
  end

  # def get_top_tracks
  #   top_tracks = current_user.get_top_tracks
  #   # render json: top_tracks
  # end

  def get_all_track_features
    render json: {tracks: current_user.tracks.map{|t| TrackSerializer.new(t)}, recent_tracks: current_user.get_recently_played}
  end

  def get_new_releases
    render json: current_user.get_new_releases
  end

  def remove_track
    spotify_id = request.headers[:id]
    track = Track.find_by(spotify_id: spotify_id)
    user_track = UserTrack.find_by(user_id: current_user.id, track_id: track.id)
    if user_track.destroy
      # delete from spotify as well
      current_user.remove_track(spotify_id)

      render json: {success: "Successfully deleted"}
    else
      render json: {error: 'Failed to delete'}, status: :not_acceptable
    end
  end

end
