# frozen_string_literal: true

require 'httparty'

# Messages a Slack webhook
module Slack
  def message(webhook_url, message_content)
    HTTParty.post(webhook_url,
                  headers: { 'Content' => 'application/json' },
                  body: message_content.to_json)
  end
end
