class LeaderboardSerializer < ActiveModel::Serializer
  attributes :id, :creator_id, :timeframe, :rank, :score

  belongs_to :creator
end
