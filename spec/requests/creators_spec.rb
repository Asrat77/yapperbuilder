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

  include_examples("request_shared_spec", "creators", 6, [:update, :destroy])

  describe "POST /creators/:id/fetch_data" do
    let(:creator) { create(:creator) }

    context "when creator exists" do
      before do
        allow(GithubFetcherService).to receive(:call).and_return({ success: true, commits_count: 100 })
        allow(TelegramFetcherService).to receive(:call).and_return({ success: true, posts_count: 50 })
      end

      it "returns a success message and updates comparison stats" do
        expect { post fetch_data_creator_url(creator), as: :json }.to change(ComparisonStat, :count).by(1)
        expect(response).to be_successful
        result = JSON(response.body)
        expect(result["success"]).to be_truthy
        expect(result["message"]).to eq 'Data fetched and comparison stats updated'

        comparison_stat = ComparisonStat.last
        expect(comparison_stat.creator).to eq creator
        expect(comparison_stat.commits_count).to eq 100
        expect(comparison_stat.posts_count).to eq 50
        expect(comparison_stat.commit_to_post_ratio).to eq 2.0
      end

      context "when GithubFetcherService fails" do
        before do
          allow(GithubFetcherService).to receive(:call).and_return({ success: false, error: "GitHub error" })
        end

        it "returns an unprocessable entity error" do
          post fetch_data_creator_url(creator), as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          result = JSON(response.body)
          expect(result["success"]).to be_falsey
          expect(result["error"]).to eq "GitHub error"
        end
      end

      context "when TelegramFetcherService fails" do
        before do
          allow(TelegramFetcherService).to receive(:call).and_return({ success: false, error: "Telegram error" })
        end

        it "returns an unprocessable entity error" do
          post fetch_data_creator_url(creator), as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          result = JSON(response.body)
          expect(result["success"]).to be_falsey
          expect(result["error"]).to eq "Telegram error"
        end
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

  describe "GET /creators/:id/comparison_ratio" do
    let(:creator) { create(:creator) }

    context "when creator exists" do
      it "returns the comparison ratio" do
        create(:comparison_stat, creator: creator, timeframe: 'daily', commit_to_post_ratio: 1.5)
        get comparison_ratio_creator_url(creator), as: :json
        expect(response).to be_successful
        result = JSON(response.body)
        expect(result["success"]).to be_truthy
        expect(result["creator_id"]).to eq creator.id
        expect(result["commit_to_post_ratio"]).to eq 1.5
      end

      it "returns not found if comparison stats do not exist" do
        get comparison_ratio_creator_url(creator), as: :json
        expect(response).to have_http_status(:not_found)
        result = JSON(response.body)
        expect(result["success"]).to be_falsey
        expect(result["error"]).to eq 'Comparison stats not found for this creator and timeframe'
      end
    end

    context "when creator does not exist" do
      it "returns a not found error" do
        get comparison_ratio_creator_url(99999), as: :json
        expect(response).to have_http_status(:not_found)
        result = JSON(response.body)
        expect(result["success"]).to be_falsey
        expect(result["error"]).to eq 'Creator not found'
      end
    end
  end
end
