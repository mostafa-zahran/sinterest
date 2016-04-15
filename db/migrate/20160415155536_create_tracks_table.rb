class CreateTracksTable < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
      t.string :name
      t.integer :user_id
      t.string :sound_track
      t.timestamps
    end
  end
end
