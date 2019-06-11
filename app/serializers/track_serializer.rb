class TrackSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :duration_ms, :explicit, :href, :name, :preview_url, :uri, :spotify_id, :spotify_url
  belongs_to :album
  has_many :artists
end
