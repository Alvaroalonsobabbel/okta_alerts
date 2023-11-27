# frozen_string_literal: true

require_relative '../helpers/application_helpers'

# Global settins
class ApplicationController < Sinatra::Base
  helpers ApplicationHelpers
  register Sinatra::ActiveRecordExtension

  set :database, YAML.safe_load(ERB.new(File.read('./config/database.yml')).result(binding), aliases: true)

  error Sinatra::NotFound do
    return 404
  end

  before do
    content_type :json

    begin
      unless request.body.read.empty? || request.path_info.in?(['/post', '/patch'])
        request.body.rewind
        @params = Sinatra::IndifferentHash.new
        @params.merge!(JSON.parse(request.body.read))
      end
    rescue JSON::ParserError => e
      halt [400, { error: 'JSON Error', message: e.message }.to_json]
    end
  end
end
