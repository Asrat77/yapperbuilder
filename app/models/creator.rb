class Creator < ApplicationRecord
  has_many :telegram_posts
  has_many :github_activities
  has_many :leaderboards

  validates :github_username, :telegram_channel, presence: true
  validates :github_username, :telegram_channel, uniqueness: true
end
