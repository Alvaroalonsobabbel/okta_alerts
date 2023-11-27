# frozen_string_literal: true

Alert.create!(event_type: 'group.user_membership.add',
              target_id: ['00g94mecoy1nH7wRP1d7'],
              slack_webhook: 'https://hooks.slack.com/services/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',
              description: 'Someone added to the Some group')

Alert.create!(event_type: 'user.session.start',
              actor_id: ['00u28g6btw2OBoq5f1d7'],
              slack_webhook: 'https://hooks.slack.com/services/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',
              description: 'person@company.com logging attempt')

Alert.create!(event_type: 'user.account.update_password',
              target_id: ['00u7nys3x0tu928bM1d7'],
              slack_webhook: 'https://hooks.slack.com/services/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',
              description: 'different_person@company.com password reset')
