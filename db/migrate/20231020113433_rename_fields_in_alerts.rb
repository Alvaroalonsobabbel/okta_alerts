# frozen_string_literal: true

# Rename fields
class RenameFieldsInAlerts < ActiveRecord::Migration[7.1]
  def change
    change_table :alerts do |t|
      t.rename :actor, :actor_id
      t.rename :target, :target_id
    end
  end
end
