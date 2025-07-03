require 'rails_helper'

RSpec.describe "Creators", type: :request do
  let(:valid_attributes) do
    {
      github_username: Faker::Internet.unique.username,
      telegram_channel: Faker::Internet.unique.url(host: 't.me'),
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

  include_examples("request_shared_spec", "creators", 6, [ :update, :destroy ])

  describe "POST /creators/:id/fetch_data" do
    let(:creator) { create(:creator) }

    context "when creator exists" do
      it "returns a success message" do
        post fetch_data_creator_url(creator), as: :json
        expect(response).to be_successful
        result = JSON(response.body)
        expect(result["success"]).to be_truthy
        expect(result["message"]).to eq 'Data fetching initiated'
      end
    end

    context "when creator does not exist" do
      it "returns a not found error" do
        post fetch_data_creator_url(99999), as: :json
        expect(response).to have_http_status(:not_found)
        result = JSON(response.body)
        expect(result["success"]).to be_falsey
        expect(result["error"]).to eq "Creator not found"
      end
    end
  end
end
