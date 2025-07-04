class LeaderboardsController < ApplicationController
  def index
    data = Leaderboard.all

    if params[:timeframe].present?
      data = data.where(timeframe: params[:timeframe])
    end

    render json: { success: true, data: ActiveModelSerializers::SerializableResource.new(data) }
  end
end
