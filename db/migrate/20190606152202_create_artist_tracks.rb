class CreateArtistTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :artist_tracks do |t|
      t.references :artist, foreign_key: true
      t.references :track, foreign_key: true
      
      t.timestamps
    end
  end
end
