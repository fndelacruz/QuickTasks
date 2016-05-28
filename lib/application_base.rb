require 'rack'
require 'pry'
require 'bcrypt'
require 'byebug'
require_relative 'active_record_lite/sql_object'
require_relative 'rails_lite/controller_base'
require_relative 'rails_lite/router'
Dir["./app/controllers/*.rb"].each { |file| require file }
Dir["./app/models/*.rb"].each do |file|
  require file;
  klass = file.match(/(\w+).rb$/)[1].camelcase.constantize
  klass.send(:finalize!)
end
