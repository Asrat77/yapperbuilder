require 'rails_helper'

RSpec.describe ComparisonStat, type: :model do
  attributes = [
    { creator: [ :belong_to ] },
    { commits_count: %i[presence numericality] },
    { posts_count: %i[presence numericality] },
    { commit_to_post_ratio: %i[presence numericality] },
    { timeframe: %i[presence] }
  ]
  include_examples("model_shared_spec", :comparison_stat, attributes)

  it { is_expected.to validate_numericality_of(:commits_count).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:posts_count).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:timeframe) }
end
