class Api::V1::SpotifyAPIAdapter < ApplicationController

  def self.refresh_token
    current_user = User.find(1)

    if current_user.access_token_expired?
      # Request a new access token using refresh token
      body = {
        grant_type: 'refresh_token',
        refresh_token: current_user.refresh_token,
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
      }

      # Send request and update user's access token
      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response)
      current_user.update(acess_token: auth_params["access_token"])
      byebug
    else
      puts "Current user's access token has not expired"
      byebug
    end

  end

end
