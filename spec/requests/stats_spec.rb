require 'rails_helper'

RSpec.describe "Stats", type: :request do
  let(:creator) { create(:creator) }

  describe "GET /creators/:creator_id/stats" do
    context "when creator exists" do
      it "returns a success response with comparison stats" do
        create_list(:comparison_stat, 3, creator: creator)
        get creator_stats_url(creator), as: :json
        expect(response).to be_successful
        result = JSON(response.body)
        expect(result["success"]).to be_truthy
        expect(result["data"].count).to eq 3
      end

      it "filters by timeframe if provided" do
        create(:comparison_stat, creator: creator, timeframe: "daily")
        create(:comparison_stat, creator: creator, timeframe: "weekly")
        get creator_stats_url(creator, timeframe: "daily"), as: :json
        expect(response).to be_successful
        result = JSON(response.body)
        expect(result["success"]).to be_truthy
        expect(result["data"].count).to eq 1
        expect(result["data"][0]["timeframe"]).to eq "daily"
      end
    end

    context "when creator does not exist" do
      it "returns a not found error" do
        get creator_stats_url(99999), as: :json
        expect(response).to have_http_status(:not_found)
        result = JSON(response.body)
        expect(result["success"]).to be_falsey
        expect(result["error"]).to eq "Creator not found"
      end
    end
  end
end
