class SpotifyApiAdapter

  def self.get_user_library(user)
    user.refresh_token
    get_library_url = "https://api.spotify.com/v1/me/tracks"
    header = {
      Authorization: "Bearer #{user.access_token}"
    }

    query_params = {
      limit: 50
    }
    url = "#{get_library_url}?#{query_params.to_query}"

    next_page = true
    response = nil
    while next_page
      new_url = !response ? url : response["next"]


      library_response = RestClient.get(new_url, header)
      response = JSON.parse(library_response.body)

      response["items"].each do |song|

        # href is api link for that specific class like Album
        album = Album.find_by(spotify_id: song["track"]["album"]["id"])
        if !album
          album = Album.create(
            name: song["track"]["album"]["name"],
            spotify_id: song["track"]["album"]["id"],
            spotify_url: song["track"]["album"]["external_urls"]["spotify"],
            href: song["track"]["album"]["href"],
            uri: song["track"]["album"]["uri"],
            image_url_small: song["track"]["album"]["images"][2]["url"],
            image_url_medium: song["track"]["album"]["images"][1]["url"],
            image_url_large: song["track"]["album"]["images"][0]["url"]
          )
        end

        track = Track.find_by(spotify_id: song["track"]["id"])
        if !track
          track = Track.create(
            name: song["track"]["name"],
            duration_ms: song["track"]["duration_ms"],
            explicit: song["track"]["explicit"],
            spotify_url: song["track"]["external_urls"]["spotify"],
            href: song["track"]["href"],
            spotify_id: song["track"]["id"],
            preview_url: song["track"]["preview_url"],
            uri: song["track"]["uri"],
            album_id: album.id
          )
        end

        album.tracks << track

        # now taking in account of multiple artists on a song
        song["track"]["artists"].each do |artist|

          # getting images from the spotify artists api
          url = "https://api.spotify.com/v1/artists/#{artist["id"]}"
          header = {
            Authorization: "Bearer #{user.access_token}"
          }
          artist_response = JSON.parse(RestClient.get(url, header))

          # putting into account if there were no images for the artist bc there isnt an image
          # for every artist on the spotify api right now.
          artistFound = Artist.find_by(name: artist["name"])
          if artist_response["images"].length == 3
            if !artistFound
              artistFound = Artist.create(
                name: artist["name"],
                spotify_url: artist["external_urls"]["spotify"],
                href: artist["href"],
                uri: artist["uri"],
                image_url_small: artist_response["images"][2]["url"],
                image_url_medium: artist_response["images"][1]["url"],
                image_url_large: artist_response["images"][0]["url"]
              )
            end
          elsif artist_response["images"].length == 2
            if !artistFound
              artistFound = Artist.create(
                name: artist["name"],
                spotify_url: artist["external_urls"]["spotify"],
                href: artist["href"],
                uri: artist["uri"],
                image_url_small: artist_response["images"][1]["url"],
                image_url_medium: artist_response["images"][0]["url"],
                image_url_large: ""
              )
            end
          else
            if !artistFound
              artistFound = Artist.create(
                name: artist["name"],
                spotify_url: artist["external_urls"]["spotify"],
                href: artist["href"],
                uri: artist["uri"],
                image_url_small: "",
                image_url_medium: "",
                image_url_large: ""
              )
            end
          end

          artist_response["genres"].each do |genre1|
            genre = Genre.find_by(name: genre1)
            if !genre
              genre = Genre.find_or_create_by(
                name: genre1
              )
              artistFound.genres << genre
            end
          end

          track.artists << artistFound
        end

        # user.tracks << track
        UserTrack.create(user_id: user.id, track_id: track.id, added_at: song["added_at"])
      end

      next_page = false if !response["next"]
    end

  end

  def self.get_recently_played(user)
    user.refresh_token
    initial_url = "https://api.spotify.com/v1/me/player/recently-played"

    header = {
      Authorization: "Bearer #{user.access_token}"
    }

    query_params = {
     limit: 50
    }
    url = "#{initial_url}?#{query_params.to_query}"

    response = JSON.parse(RestClient.get(url, header))

  end

  def self.get_top_tracks(user)
    user.refresh_token
    initial_url = "https://api.spotify.com/v1/me/top/tracks"

    header = {
      Authorization: "Bearer #{user.access_token}"
    }

    query_params = {
     limit: 50
    }
    url = "#{initial_url}?#{query_params.to_query}"
    response = JSON.parse(RestClient.get(url, header))
  end

  def self.get_recommendations(user)
    user.refresh_token
    initial_url = "https://api.spotify.com/v1/recommendations"

    header = {
      Authorization: "Bearer #{user.access_token}"
    }

    query_params = {
     limit: 30
    }
    url = "#{initial_url}?#{query_params.to_query}"
    response = JSON.parse(RestClient.get(url, header))
  end


end
