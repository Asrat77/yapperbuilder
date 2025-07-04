class CreatorsController < ApplicationController
  def index
    @creators = Creator.all
    render json: { success: true, data: ActiveModelSerializers::SerializableResource.new(@creators) }
  end

  def show
    @creator = Creator.find(params[:id])
    render json: { success: true, data: ActiveModelSerializers::SerializableResource.new(@creator) }
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Creator not found" }, status: :not_found
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

    github_result = GithubFetcherService.call(@creator)
    telegram_result = TelegramFetcherService.call(@creator)

    unless github_result[:success]
      return render json: { success: false, error: github_result[:error] }, status: :unprocessable_entity
    end

    unless telegram_result[:success]
      return render json: { success: false, error: telegram_result[:error] }, status: :unprocessable_entity
    end

    commits_count = github_result[:commits_count]
    posts_count = telegram_result[:posts_count]

    # Calculate commit_to_post_ratio
    commit_to_post_ratio = posts_count > 0 ? commits_count.to_f / posts_count : 0.0

    # For simplicity, using 'daily' as timeframe for now. This could be dynamic.
    timeframe = 'daily'

    comparison_stat = ComparisonStat.find_or_initialize_by(creator: @creator, timeframe: timeframe)
    comparison_stat.commits_count = commits_count
    comparison_stat.posts_count = posts_count
    comparison_stat.commit_to_post_ratio = commit_to_post_ratio

    if comparison_stat.save
      render json: { success: true, message: 'Data fetched and comparison stats updated' }, status: :ok
    else
      render json: { success: false, error: comparison_stat.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Creator not found' }, status: :not_found
  end

  def comparison_ratio
    @creator = Creator.find(params[:id])
    # Assuming 'daily' is the relevant timeframe for the latest ratio
    comparison_stat = @creator.comparison_stats.find_by(timeframe: 'daily')

    if comparison_stat
      render json: { success: true, creator_id: @creator.id, commit_to_post_ratio: comparison_stat.commit_to_post_ratio }, status: :ok
    else
      render json: { success: false, error: 'Comparison stats not found for this creator and timeframe' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Creator not found' }, status: :not_found
  end

  private

  def creator_params
    params.require(:payload).permit(:github_username, :telegram_channel, :name, :avatar_url, :bio)
  end
end
