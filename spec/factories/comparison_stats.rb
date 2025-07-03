FactoryBot.define do
  factory :comparison_stat do
    association :creator
    commits_count { Faker::Number.between(from: 0, to: 100) }
    posts_count { Faker::Number.between(from: 0, to: 100) }
    commit_to_post_ratio { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    timeframe { ['daily', 'weekly', 'monthly'].sample }
  end
end
