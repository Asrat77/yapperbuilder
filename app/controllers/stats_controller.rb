class StatsController < ApplicationController
  def index
    @creator = Creator.find(params[:creator_id])
    data = @creator.comparison_stats

    if params[:timeframe].present?
      data = data.where(timeframe: params[:timeframe])
    end

    render json: { success: true, data: ActiveModelSerializers::SerializableResource.new(data) }
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Creator not found" }, status: :not_found
  end
end
