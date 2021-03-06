class User < ApplicationRecord
  has_many :user_tracks, dependent: :destroy
  has_many :tracks,  -> { distinct }, through: :user_tracks

  has_many :reviews

  has_many :artists, -> { distinct }, through: :tracks

  has_many :genres, -> { distinct }, through: :artists

  def access_token_expired?
    #return true if access_token is older than 55 minutes, based on update_at
    (Time.now - self.updated_at) > 3300
  end

  def refresh_token

    if self.access_token_expired?
      # Request a new access token using refresh token
      body = {
        grant_type: 'refresh_token',
        refresh_token: self.refresh_token,
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
      }

      # Send request and update user's access token
      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response)
      self.update(access_token: auth_params["access_token"])
    else
      puts "Current user's access token has not expired"
    end

  end

  def get_library
    SpotifyApiAdapter.get_user_library(self)
  end

  def get_recently_played
    SpotifyApiAdapter.get_recently_played(self)
  end

  # def get_top_tracks
  #   SpotifyApiAdapter.get_top_tracks(self)
  # end

  def get_recommendations
    SpotifyApiAdapter.get_recommendations(self)
  end

  def get_new_releases
    SpotifyApiAdapter.get_new_releases(self)
  end

  def remove_track(id)
    SpotifyApiAdapter.remove_track(self, id)
  end

  def get_featured_playlists
    SpotifyApiAdapter.get_featured_playlists(self)
  end

end
