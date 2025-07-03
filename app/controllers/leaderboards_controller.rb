class LeaderboardsController < ApplicationController
  include Common

  def index
    data = @clazz.all

    if params[:timeframe].present?
      data = data.where(timeframe: params[:timeframe])
    end

    render json: { success: true, data: serialize(data) }
  end

  private

  def set_clazz
    @clazz = Leaderboard # Explicitly set the class for Common concern
  end
end
