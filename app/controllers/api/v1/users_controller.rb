class Api::V1::UsersController < ApplicationController

  def spotify_create
    url = "https://accounts.spotify.com/authorize"
    query_params = {
      response_type: "code",
      client_id: ENV['CLIENT_ID'],
      redirect_uri: ENV['REDIRECT_URI'],
      scope: "user-library-read user-library-modify user-read-recently-played user-modify-playback-state playlist-modify-public",
      show_dialog: true
    }
    redirect_to "#{url}?#{query_params.to_query}"

  end

  def create
    body = {
      grant_type: "authorization_code",
      code: params[:code],
      redirect_uri: ENV['REDIRECT_URI'],
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV["CLIENT_SECRET"]
    }
    auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
    # convert response.body to json for assisgnment
    auth_params = JSON.parse(auth_response.body)

    header = {
      Authorization: "Bearer #{auth_params["access_token"]}"
    }
    user_response = RestClient.get("https://api.spotify.com/v1/me", header)
    # convert response.body to json for assisgnment
    user_params = JSON.parse(user_response.body)
    # Create new user based on response, or find the existing user in database
    @user = User.find_or_create_by(username: user_params["id"],
                      spotify_url: user_params["external_urls"]["spotify"],
                      href: user_params["href"],
                      uri: user_params["uri"])
    # Add or update user's profile image:
    img_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
    @user.update(profile_img_url: img_url)
    # Update the access and refresh tokens in the database
    @user.update(access_token:auth_params["access_token"], refresh_token: auth_params["refresh_token"])
    byebug
    redirect_to "http://localhost:3000/user"
    byebug
  end

  def show
    # render json: {
    #   username: current_user.username,
    #   spotify_url: current_user.spotify_url,
    #   profile_img_url: current_user.profile_img_url
    # }
  end

end
