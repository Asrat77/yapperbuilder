class CreateGithubActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :github_activities do |t|
      t.references :creator, null: false, foreign_key: true
      t.string :repo
      t.integer :commits_count
      t.string :timeframe

      t.timestamps
    end
  end
end
