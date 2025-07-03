require 'rails_helper'

RSpec.describe TelegramPost, type: :model do
  attributes = [
    { creator: [:belong_to] },
    { message_id: %i[presence] },
    { text: %i[presence] },
    { posted_at: %i[presence] },
    { timeframe: %i[presence] }
  ]
  include_examples("model_shared_spec", :telegram_post, attributes)

  it { is_expected.to validate_uniqueness_of(:message_id).scoped_to(:creator_id) }
end
