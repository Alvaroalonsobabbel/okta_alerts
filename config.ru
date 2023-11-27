# frozen_string_literal: true

require 'rack'
require 'rack/contrib'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'app/controllers/application_controller'
require_relative 'app/controllers/events_controller'
require_relative 'app/controllers/alerts_controller'
require_relative 'app/helpers/secrets_manager'

SecretsManager::Variables.set_variables

set :root, File.dirname(__FILE__)

map('/alerts') { run AlertsController }
map('/events') { run EventsController }
