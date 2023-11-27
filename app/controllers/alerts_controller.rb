# frozen_string_literal: true

require_relative 'application_controller'
require_relative '../models/alert'

# CRUD operations for Alerts
class AlertsController < ApplicationController
  before { authenticate!('alerts') }

  get '/' do
    { data: Alert.all }.to_json
  end

  get '/:id' do
    alert = Alert.find_by(id: params[:id])
    return 404 if alert.nil?

    { data: alert }.to_json
  end

  post '/' do
    alert = Alert.create!(param_validator!)

    [201, { data: alert, status: 'Created' }.to_json]
  rescue ActiveRecord::RecordInvalid, ActiveRecord::SerializationTypeMismatch => e
    [422, { error: e }.to_json]
  end

  patch '/:id' do
    alert = Alert.find_by(id: params[:id])
    return 404 if alert.nil?

    alert.update!(param_validator!)

    [200, { data: alert, status: 'Updated' }.to_json]
  rescue ActiveRecord::RecordInvalid, ActiveRecord::SerializationTypeMismatch => e
    [422, { error: e }.to_json]
  end

  delete '/:id' do
    Alert.find_by!(id: params[:id]).delete
    204
  rescue ActiveRecord::RecordNotFound
    404
  end

  # test endpoints to delete

  get '/alerts/db' do
    [200, { db: ActiveRecord::Base.configurations }.to_json]
  end

  get '/alerts/env' do
    [200, { is_in_prod: settings.production?, is_in_dev: settings.development? }.to_json]
  end

  get '/alerts/var' do
    [200,
     { name: ENV['DATABASE_NAME'], host: ENV['DATABASE_HOST'], usr: ENV['DATABASE_USER'],
       pwd: ENV['DATABASE_PASSWORD'], eventskey: ENV['EVENTS_API_KEY'], alertskey: ENV['ALERTS_API_KEY'] }.to_json]
  end

  get '/alerts/par' do
    [200, { param: File.read('./config/database.yml') }.to_json]
  end
end
