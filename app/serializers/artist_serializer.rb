class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :href, :id, :image_url_small, :image_url_medium, :image_url_large, :name, :spotify_id, :spotify_url, :uri
  has_many :tracks
end
