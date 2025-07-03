class Leaderboard < ApplicationRecord
  belongs_to :creator

  validates :timeframe, :rank, :score, presence: true
  validates :rank, numericality: { greater_than: 0 }
  validates :score, numericality: true
  validates :creator_id, uniqueness: { scope: :timeframe }
end
