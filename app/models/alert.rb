# frozen_string_literal: true

# Alert Model
class Alert < ActiveRecord::Base
  serialize :actor_id, type: Array
  serialize :target_id, type: Array
  validates :event_type, presence: true
  validates :slack_webhook, presence: true
end
