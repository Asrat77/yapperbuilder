class CreatorSerializer < ActiveModel::Serializer
  attributes :id, :github_username, :telegram_channel, :name, :avatar_url, :bio
end
