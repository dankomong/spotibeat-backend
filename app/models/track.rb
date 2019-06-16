class Track < ApplicationRecord
  has_many :user_tracks
  has_many :users, through: :user_tracks

  has_many :artist_tracks
  has_many :artists, through: :artist_tracks

  has_many :reviews

  has_many :genres, through: :artists

  belongs_to :album

end
