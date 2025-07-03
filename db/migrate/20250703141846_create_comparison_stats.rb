class CreateComparisonStats < ActiveRecord::Migration[8.0]
  def change
    create_table :comparison_stats do |t|
      t.references :creator, null: false, foreign_key: true
      t.integer :commits_count
      t.integer :posts_count
      t.float :commit_to_post_ratio
      t.string :timeframe

      t.timestamps
    end
  end
end
