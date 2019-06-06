class User < ApplicationRecord
  has_many :user_tracks, dependent: :destroy
  has_many :tracks, through: :user_tracks

  has_many :artists, through: :tracks

  has_many :genres, through: :artists

  def access_token_expired?
    #return true if access_token is older than 55 minutes, based on update_at
    (Time.now - self.updated_at) > 3300
  end

end
