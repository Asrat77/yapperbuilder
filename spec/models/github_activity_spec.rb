require 'rails_helper'

RSpec.describe GithubActivity, type: :model do
  attributes = [
    { creator: [ :belong_to ] },
    { repo: %i[presence] },
    { commits_count: %i[presence numericality] },
    { timeframe: %i[presence] }
  ]
  include_examples("model_shared_spec", :github_activity, attributes)

  it { is_expected.to validate_uniqueness_of(:repo).scoped_to(%i[creator_id timeframe]) }
  it { is_expected.to validate_numericality_of(:commits_count).is_greater_than_or_equal_to(0) }
end
