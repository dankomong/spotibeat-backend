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

end
