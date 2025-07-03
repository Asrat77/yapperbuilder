require 'rails_helper'

RSpec.describe Leaderboard, type: :model do
  attributes = [
    { creator: [ :belong_to ] },
    { timeframe: %i[presence] },
    { rank: %i[presence numericality] },
    { score: %i[presence numericality] }
  ]
  include_examples("model_shared_spec", :leaderboard, attributes)

  it { is_expected.to validate_numericality_of(:rank).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:timeframe) }
end
