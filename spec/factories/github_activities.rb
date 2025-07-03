FactoryBot.define do
  factory :github_activity do
    association :creator
    repo { Faker::Internet.url(host: 'github.com') }
    commits_count { Faker::Number.between(from: 0, to: 100) }
    timeframe { ['daily', 'weekly', 'monthly'].sample }
  end
end
