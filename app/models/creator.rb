class Creator < ApplicationRecord
  validates :github_username, :telegram_channel, presence: true
  validates :github_username, :telegram_channel, uniqueness: true
end
