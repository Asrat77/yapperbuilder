class TelegramPost < ApplicationRecord
  belongs_to :creator

  validates :message_id, :text, :posted_at, :timeframe, presence: true
  validates :message_id, uniqueness: { scope: :creator_id }
end
