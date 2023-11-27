# frozen_string_literal: true

# ChangeColumnType
class ChangeColumnType < ActiveRecord::Migration[7.1]
  def change
    change_table :alerts do |t|
      t.change :event_type, :string
    end
  end
end
