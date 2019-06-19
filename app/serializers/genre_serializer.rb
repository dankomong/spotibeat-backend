class GenreSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :tracks
  has_many :artists, through: :artist_genres, serializer: ArtistSerializer
end
