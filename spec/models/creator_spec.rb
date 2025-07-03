require 'rails_helper'

RSpec.describe Creator, type: :model do
  attributes = [
    { telegram_channel: %i[presence uniqueness] },
    { github_username: %i[presence uniqueness] }
  ]
  include_examples("model_shared_spec", :creator, attributes)
end
