class Api::V1::TracksController < ApplicationController

  def index
    tracks = current_user.tracks
    render json: tracks
  end

  def get_recently_played
    recent_tracks = current_user.get_recently_played
    render json: recent_tracks
  end

end
