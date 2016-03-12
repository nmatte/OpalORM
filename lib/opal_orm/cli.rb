require 'thor'
require_relative 'query_builder'
require_relative 'db_connection'
require_relative 'schema_manager'
require_relative 'util'

module OpalORM
  class DatabaseManager < Thor
    desc "create", "Create the database to be used by OpalORM"
    long_desc <<-CREATE
    Create an empty SQLite database in /db/opal.db.
    CREATE

    def create
      Util.ensure_db_dir
      db_file_path = File.join(Util.db_path, "opal.db")
      puts "Creating db/opal.db ..."
      DBConnection.open(db_file_path)
      if File.exist?(db_file_path)
        puts "opal.db successfully created."
      end
    end

    desc "generate SCHEMA_NAME TABLE1 TABLE2 ... ", "Create a blank schema file to be edited"
    long_desc <<-GENERATE
    Create a blank schema file called schema.rb. In it you can use the OpalORM
    DSL to create tables with different datatypes.
    Then create the schema with `db make`.
    You may optionally pass the table names that you want to create. Otherwise you
    will have to add them yourself.
    GENERATE

    def generate(file_name, *table_names)
      OpalORM::SchemaManager.generate(file_name, *table_names)
    rescue FileExistsError => e
      puts e.message
      puts "Aborting."
    end
  end

end
