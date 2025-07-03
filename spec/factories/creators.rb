FactoryBot.define do
  factory :creator do
    github_username { Faker::Internet.unique.username }
    telegram_channel { Faker::Internet.unique.url(host: 't.me') }
    name { Faker::Name.name }
    avatar_url { Faker::Lorem.word }
    bio { Faker::Lorem.sentence }
  end
end
