class CreateLeaderboards < ActiveRecord::Migration[8.0]
  def change
    create_table :leaderboards do |t|
      t.references :creator, null: false, foreign_key: true
      t.string :timeframe
      t.integer :rank
      t.float :score

      t.timestamps
    end
  end
end
