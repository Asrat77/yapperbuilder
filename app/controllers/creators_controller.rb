class CreatorsController < ApplicationController
  def index
    @creators = Creator.all
    render json: { success: true, data: ActiveModelSerializers::SerializableResource.new(@creators) }
  end

  def show
    @creator = Creator.find(params[:id])
    render json: { success: true, data: ActiveModelSerializers::SerializableResource.new(@creator) }
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Creator not found' }, status: :not_found
  end

  def create
    @creator = Creator.new(creator_params)

    if @creator.save
      render json: { success: true, data: ActiveModelSerializers::SerializableResource.new(@creator) }, status: :created
    else
      render json: { success: false, error: @creator.errors.full_messages[0] }, status: :unprocessable_entity
    end
  rescue => e
    render json: { success: false, error: e.message }
  end

  def fetch_data
    @creator = Creator.find(params[:id])
    GithubFetcherService.call(@creator)
    telegram_result = TelegramFetcherService.call(@creator)

    if telegram_result[:success]
      render json: { success: true, message: 'Data fetching initiated' }, status: :ok
    else
      render json: { success: false, error: telegram_result[:error] }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Creator not found' }, status: :not_found
  end

  private

  def creator_params
    params.require(:payload).permit(:github_username, :telegram_channel, :name, :avatar_url, :bio)
  end
end
