# frozen_string_literal: true

# Alert Filter
class AlertFilter
  def initialize(event)
    @event_type = event[:eventType]
    @event_actor_id = event[:actor][:id]
    @event_target_ids = event[:target].map { |k, _v| k[:id] }
  end

  def filter
    # Retrieves all the alerts matching the event_type from the DB
    alerts = Alert.where(event_type: @event_type).to_a

    # Filters the alerts array with Events matching the actor_id
    alerts.select! do |alert|
      @event_actor_id.in?(alert.actor_id) || alert.actor_id.empty?
    end

    # Filters the alerts array with Events matching the target_id
    alerts.select do |alert|
      @event_target_ids.intersect?(alert.target_id) || alert.target_id.empty?
    end
  end
end
