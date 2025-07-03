FactoryBot.define do
  factory :creator do
    github_username { Faker::Name.name }
    telegram_channel { Faker::Name.name }
    name { Faker::Name.name }
    avatar_url { Faker::Lorem.word }
    bio { Faker::Lorem.sentence }
  end
end
