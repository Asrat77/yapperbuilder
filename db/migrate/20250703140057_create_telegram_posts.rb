class CreateTelegramPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :telegram_posts do |t|
      t.references :creator, null: false, foreign_key: true
      t.integer :message_id
      t.text :text
      t.datetime :posted_at
      t.string :timeframe

      t.timestamps
    end
  end
end
