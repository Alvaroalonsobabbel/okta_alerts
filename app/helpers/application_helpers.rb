# frozen_string_literal: true

# Application Helpers
module ApplicationHelpers
  # Validates params passed to POST and PATCH operations.
  # Ensures that:
  #   - main data object is present and contains a hash
  #   - any of the valid params are present
  #   - only valid params are sent to the operation
  def param_validator!
    valid_data_params ||= %w[event_type actor_id target_id slack_webhook description]

    halt [422, { error: 'Main \'data\' object is missing.' }.to_json] unless @params[:data]

    if (valid_data_params & (@params[:data]).keys).empty?
      halt [422,
            { error: "No valid params present: #{valid_data_params.join(', ')}" }.to_json]
    end

    @params[:data].select { |k, _v| k.in?(valid_data_params) }
  rescue NoMethodError
    halt [422, { error: "\'data\' object should contain a hash" }.to_json]
  end

  def authenticate!(type)
    return if request.env['HTTP_AUTHORIZATION'] == "Bearer #{ENV["#{type.upcase}_API_KEY"]}"

    halt [401, { error: "Invalid #{type.capitalize} API key" }.to_json]
  end
end
