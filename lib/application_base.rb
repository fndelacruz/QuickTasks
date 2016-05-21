require 'rack'
require 'pry'
require_relative 'active_record_lite/sql_object'
require_relative 'rails_lite/controller_base'
require_relative 'rails_lite/router'
Dir["./app/controllers/*.rb"].each { |file| require file }
Dir["./app/models/*.rb"].each { |file| require file }
