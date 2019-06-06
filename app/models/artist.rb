class Artist < ApplicationRecord
  has_many :artist_tracks
  has_many :tracks, through: :artist_tracks

  has_many :artist_genres
  has_many :genres, through: :artist_genres

end
