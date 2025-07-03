FactoryBot.define do
  factory :leaderboard do
    association :creator
    timeframe { [ 'daily', 'weekly', 'monthly' ].sample }
    rank { Faker::Number.between(from: 1, to: 100) }
    score { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
