# frozen_string_literal: true

# ModifyEventTypeIndex
class ModifyEventTypeIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :alerts, ['event_type']
    add_index :alerts, :event_type
  end
end
