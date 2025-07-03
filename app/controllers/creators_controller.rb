class CreatorsController < ApplicationController
  include Common

  def fetch_data
    @creator = Creator.find(params[:id])
    GithubFetcherService.call(@creator)
    TelegramFetcherService.call(@creator)
    render json: { success: true, message: "Data fetching initiated" }
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Creator not found" }, status: :not_found
  end

  private

  def model_params
    params.require(:payload).permit(:github_username, :telegram_channel, :name, :avatar_url, :bio)
  end
end
