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
    auth_params = {}
    if params[:code]
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

    elsif params[:access_token]
      auth_params["access_token"] = params[:access_token]
    end

    header = {
      Authorization: "Bearer #{auth_params["access_token"]}"
    }
    user_response = RestClient.get("https://api.spotify.com/v1/me", header)
    # convert response.body to json for assisgnment
    user_params = JSON.parse(user_response.body)
    # Create new user based on response, or find the existing user in database
    @user = User.find_or_create_by(username: user_params["id"],
                      spotify_url: user_params["external_urls"]["spotify"],
                      followers: user_params["followers"]["total"],
                      href: user_params["href"],
                      uri: user_params["uri"])
    # Add or update user's profile image:
    img_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
    @user.update(profile_img_url: img_url)
    # Update the access and refresh tokens in the database
    @user.update(access_token:auth_params["access_token"], refresh_token: auth_params["refresh_token"])

    # redirect_to "http://localhost:3000/home"
    render json: {token: @user.access_token, user: UserSerializer.new(@user)}
  end

  def get_genres_and_artists_unique
    genres = Genre.all
    artists = Artist.all
    render json: {genres: genres, artists: artists}
  end

  def get_library
    # separate method on user model
    # just runs once (for now) to seed the data into the database
    current_user.get_library
  end

  def get_recommendations
    current_user.get_recommendations
  end


end
