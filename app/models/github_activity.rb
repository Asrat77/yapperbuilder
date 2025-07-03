class GithubActivity < ApplicationRecord
  belongs_to :creator

  validates :repo, :commits_count, :timeframe, presence: true
  validates :commits_count, numericality: { greater_than_or_equal_to: 0 }
  validates :repo, uniqueness: { scope: %i[creator_id timeframe] }
end
