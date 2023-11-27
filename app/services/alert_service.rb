# frozen_string_literal: true

require_relative '../helpers/alert_filter'
require_relative '../helpers/slack_block'
require_relative '../helpers/slack'

# This service will receive an event, match it with possible alerts,
# create the body of the Slack message and send it
class AlertService
  include Slack

  def initialize(event)
    @event = event
  end

  def call
    alerts_matching_event = AlertFilter.new(@event).filter

    return if alerts_matching_event.empty?

    event_info = SlackBlock::Generate.event(@event)

    alerts_matching_event.uniq.each do |alert|
      to_send = Sinatra::IndifferentHash.new
      to_send.merge!(event_info)

      to_send[:attachments][0][:blocks] << { type: :divider }
      to_send[:attachments][0][:blocks] << SlackBlock::Generate.alert(alert)

      message(alert.slack_webhook, to_send)
    end
  end
end
