class GenreSerializer < ActiveModel::Serializer
  attributes :name
  has_many :tracks
end
