require 'rails_helper'

RSpec.describe "Creators", type: :request do
  let(:valid_attributes) do
    {
      github_username: Faker::Internet.username,
      telegram_channel: Faker::Internet.url(host: 't.me'),
      name: Faker::Name.name,
      avatar_url: Faker::Avatar.image,
      bio: Faker::Lorem.sentence
    }
  end

  let(:invalid_attributes) do
    {
      github_username: nil,
      telegram_channel: nil
    }
  end

  let(:new_attributes) do
    {
      name: Faker::Name.name
    }
  end

  include_examples("request_shared_spec", "creators", 5, [:update, :destroy])
end
