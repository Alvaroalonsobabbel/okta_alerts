# frozen_string_literal: true

# RSpec Helpers
module Helpers
  include Rack::Test::Methods

  def json_body
    JSON.parse(last_response.body)
  end

  def app
    @app ||= Rack::Builder.parse_file('./config.ru').first
  end
end
