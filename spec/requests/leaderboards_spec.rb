require 'rails_helper'

RSpec.describe "Leaderboards", type: :request do
  describe "GET /leaderboards" do
    it "returns a success response with leaderboards" do
      create_list(:leaderboard, 3)
      get leaderboards_url, as: :json
      expect(response).to be_successful
      result = JSON(response.body)
      expect(result["success"]).to be_truthy
      expect(result["data"].count).to eq 3
    end

    it "filters by timeframe if provided" do
      create(:leaderboard, timeframe: "daily")
      create(:leaderboard, timeframe: "weekly")
      get leaderboards_url(timeframe: "daily"), as: :json
      expect(response).to be_successful
      result = JSON(response.body)
      expect(result["success"]).to be_truthy
      expect(result["data"].count).to eq 1
      expect(result["data"][0]["timeframe"]).to eq "daily"
    end
  end
end
