require 'net/http'
require 'uri'
require 'json'

class TelegramFetcherService
  # Ideally, this base URL would be configured via environment variables or Rails credentials.
  TELEGRAM_API_BASE_URL = "https://1c94-196-189-127-39.ngrok-free.app"

  def self.call(creator)
    channel_identifier = creator.telegram_channel
    # Ensure the channel_identifier is URL-encoded
    uri = URI("#{TELEGRAM_API_BASE_URL}/telegram/posts_count?channel_identifier=#{URI.encode_www_form_component(channel_identifier)}")

    begin
      response = Net::HTTP.get_response(uri)
      response_body = JSON.parse(response.body)

      if response.is_a?(Net::HTTPSuccess) && response_body["success"]
        { success: true, posts_count: response_body["posts_count"] }
      else
        # Handle non-2xx responses or success: false in the JSON body
        error_message = response_body["error"] || "Unknown error from Telegram service (HTTP Status: #{response.code})"
        { success: false, error: error_message }
      end
    rescue JSON::ParserError
      { success: false, error: "Invalid JSON response from Telegram service" }
    rescue Net::ReadTimeout, Net::OpenTimeout
      { success: false, error: "Timeout connecting to Telegram service" }
    rescue StandardError => e
      { success: false, error: "Error connecting to Telegram service: #{e.message}" }
    end
  end
end