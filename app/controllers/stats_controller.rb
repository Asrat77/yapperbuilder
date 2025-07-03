class StatsController < ApplicationController
  include Common

  def index
    @creator = Creator.find(params[:creator_id])
    data = @creator.comparison_stats

    if params[:timeframe].present?
      data = data.where(timeframe: params[:timeframe])
    end

    render json: { success: true, data: serialize(data) }
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Creator not found" }, status: :not_found
  end

  private

  def model_params
    # Not directly used for GET requests, but required by Common concern
    params.permit(:timeframe)
  end

  def set_clazz
    @clazz = ComparisonStat # Explicitly set the class for Common concern
  end
end
