# frozen_string_literal: true

# AddDescriptionToAlerts
class AddDescriptionToAlerts < ActiveRecord::Migration[7.1]
  def change
    add_column :alerts, :description, :text
  end
end
