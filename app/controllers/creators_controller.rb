class CreatorsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:creator).permit(:github_username, :telegram_channel, :name, :avatar_url, :bio)
  end
end
