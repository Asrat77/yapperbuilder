FactoryBot.define do
  factory :telegram_post do
    association :creator
    message_id { Faker::Number.unique.between(from: 1, to: 10000) }
    text { Faker::Lorem.paragraph }
    posted_at { Faker::Time.between(from: DateTime.now - 30, to: DateTime.now) }
    timeframe { [ 'daily', 'weekly', 'monthly' ].sample }
  end
end
