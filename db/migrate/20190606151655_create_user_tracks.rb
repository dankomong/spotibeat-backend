class CreateUserTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tracks do |t|
      t.datetime :added_at
      t.references :user, foreign_key: true
      t.references :track, foreign_key: true

      t.timestamps
    end
  end
end
