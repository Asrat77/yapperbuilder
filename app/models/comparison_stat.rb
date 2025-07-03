class ComparisonStat < ApplicationRecord
  belongs_to :creator

  validates :commits_count, :posts_count, :commit_to_post_ratio, :timeframe, presence: true
  validates :commits_count, :posts_count, numericality: { greater_than_or_equal_to: 0 }
  validates :commit_to_post_ratio, numericality: true
  validates :creator_id, uniqueness: { scope: :timeframe }
end
