class CreateCreators < ActiveRecord::Migration[8.0]
  def change
    create_table :creators do |t|
      t.string :github_username, null: false
      t.string :telegram_channel, null: false
      t.string :name
      t.string :avatar_url
      t.string :bio

      t.timestamps
    end
    add_index :creators, :github_username, unique: true
    add_index :creators, :telegram_channel, unique: true
  end
end
