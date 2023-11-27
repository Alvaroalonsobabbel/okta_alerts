# frozen_string_literal: true

require 'aws-sdk-secretsmanager'

# Retrieves secrets from AWS Secrets Manager
module SecretsManager
  # Define neccesary variables depending on local or AWS usage
  # Variables can either be passed local as environmental variables
  # or through AWS SecretsManager
  class Variables
    class << self
      def set_variables
        variables = %w[OKTA_ADMIN_BASE_URL
                       DATABASE_HOST
                       DATABASE_NAME
                       DATABASE_USER
                       DATABASE_PASSWORD
                       EVENTS_API_KEY
                       ALERTS_API_KEY]

        secrets
        variables.each { |var| ENV[var] = @secrets[var] }
      end

      private

      def aws_secret(secret)
        client = Aws::SecretsManager::Client.new(region: 'eu-central-1')

        begin
          get_secret_value_response = client.get_secret_value(secret_id: secret)
        rescue StandardError => e
          raise e
        end

        get_secret_value_response.secret_string
      end

      def secrets
        @secrets ||= JSON.parse(aws_secret('okta_alerts_test'))
      end
    end
  end
end
