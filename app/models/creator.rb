class Creator < ApplicationRecord
  has_many :telegram_posts

  validates :github_username, :telegram_channel, presence: true
  validates :github_username, :telegram_channel, uniqueness: true
end
