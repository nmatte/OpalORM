require "opal_orm/version"
require_relative "opal_orm/cli"
require_relative 'opal_orm/db_connection'
require_relative 'opal_orm/sql_object'
require_relative 'opal_orm/schema_manager'
require_relative 'opal_orm/searchable'
require_relative 'opal_orm/associatable'

module OpalORM
  CURRENT_PATH = Dir.pwd
  CONFIG_PATH = File.join(CURRENT_PATH, 'db/opal_config.json')
  DB_PATH = File.join(CURRENT_PATH, 'db')
  # Your code goes here...
end
