class ComparisonStatSerializer < ActiveModel::Serializer
  attributes :id, :creator_id, :commits_count, :posts_count, :commit_to_post_ratio, :timeframe
end
