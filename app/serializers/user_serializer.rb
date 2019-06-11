class UserSerializer < ActiveModel::Serializer
  attributes :id, :followers, :profile_img_url, :username, :spotify_url, :href
  has_many :tracks

end
