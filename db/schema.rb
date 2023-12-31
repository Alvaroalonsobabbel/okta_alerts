# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_231_028_100_020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'alerts', force: :cascade do |t|
    t.string 'event_type'
    t.text 'actor_id'
    t.text 'target_id'
    t.string 'slack_webhook'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'description'
    t.index ['event_type'], name: 'index_alerts_on_event_type'
  end
end
