# frozen_string_literal: true

# Helper to generate Slack Blocks
module SlackBlock
  # Digest event information into a Slack message
  class Generate
    class << self
      def event(event)
        # Creates the Main block
        event_info = payload
        event_info[:attachments][0][:blocks][0][:text][:text] = ":rotating_light: #{event['eventType']}"
        @event_block = block

        # Adds the Outcome & Link
        @event_block[:elements][0][:text] = "*Outcome:* #{event['outcome']['result']}\n"
        add_to_block("*Outcome Reason:* #{event['outcome']['reason']}\n") unless event['outcome']['reason'].nil?
        add_to_block(
          "<https://#{ENV['OKTA_ADMIN_BASE_URL']}/report/system_log_2?search=#{event['uuid']}|View in System Log>\n"
        )

        # Adds the Actor
        add_to_block("*Actor*\n")
        add_to_block("displayName: #{event['actor']['displayName']}\n")
        unless event['actor']['alternateId'] == 'unknown' ||
               event['actor']['alternateId'] == event['actor']['displayName']
          add_to_block("alternateId:    #{event['actor']['alternateId']}\n")
        end
        add_to_block("type:               #{event['actor']['type']} (#{event['actor']['id']})\n")

        # Adds the Targets
        event['target'].each do |target|
          add_to_block("*Target*\n")
          add_to_block("displayName: #{target['displayName']}\n")
          unless target['alternateId'] == 'unknown' || target['alternateId'] == target['displayName']
            add_to_block("alternateId:    #{target['alternateId']}\n")
          end
          add_to_block("type:               #{target['type']} (#{target['id']})\n")
        end

        event_info[:attachments][0][:blocks] << @event_block
        event_info
      end

      # Digest Alert information for the payload

      def alert(alert)
        footer = block

        footer[:elements][0][:text] = "*Alert Details* (alert_id: #{alert.id})\n"
        footer[:elements][0][:text] += "Description: #{alert.description}\n"
        footer[:elements][0][:text] += "Date: #{Time.now}"

        footer
      end

      private

      def payload
        {
          username: 'Okta Alerts',
          attachments: [
            {
              color: '#f2c744',
              blocks: [
                { type: :header,
                  text:
                  {
                    type: :plain_text,
                    emoji: true
                  } },
                { type: :divider }
              ]
            }
          ]
        }
      end

      def block
        {
          type: :context,
          elements: [
            {
              type: :mrkdwn,
              verbatim: true
            }
          ]
        }
      end

      def add_to_block(thing)
        @event_block[:elements][0][:text] += thing
      end
    end
  end
end
