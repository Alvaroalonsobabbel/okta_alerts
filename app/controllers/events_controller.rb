# frozen_string_literal: true

require_relative 'application_controller'
require_relative '../services/alert_service'

# Events Controller
class EventsController < ApplicationController
  before { authenticate!('events') }

  # Webhook verification endpoint required by Okta:
  # https://developer.okta.com/docs/concepts/event-hooks/#one-time-verification-request
  get '/' do
    { 'verification': request.env['HTTP_X_OKTA_VERIFICATION_CHALLENGE'] }.to_json
  end

  post '/' do
    # In the case of multiple nested events it might take more than 3 seconds
    # to process all the backlog and respond 200 to the webhook. Forking here
    # responds 200 immediately, preventing the webhook to retry sending the Events
    fork do
      @params[:data][:events].each { |event| AlertService.new(event).call }
    end
    return 200
  end
end
