# frozen_string_literal: true

# Create the Alerts Table
class CreateAlertsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :alerts do |t|
      t.text :event_type, index: true
      t.text :actor
      t.text :target
      t.string :slack_webhook

      t.timestamps
    end
  end
end
