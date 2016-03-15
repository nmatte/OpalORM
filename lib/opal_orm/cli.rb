require 'thor'
require_relative 'query_builder'
require_relative 'db_connection'
require_relative 'schema_manager'
require_relative 'util'

module OpalORM
  class DatabaseManager < Thor
    desc "new DATABASE_NAME", "Create the database to be used by OpalORM"
    long_desc <<-CREATE
    Create an empty SQLite database in /db/DATABASE_NAME.db.
    CREATE

    def new(db_name)
      Util.ensure_db_dir
      name_with_ext = "#{db_name}.db"
      db_file_path = File.join(Util.db_path, name_with_ext)
      puts "Creating db/#{name_with_ext} ..."
      DBConnection.open(db_file_path)
      if File.exist?(db_file_path)
        Util.ensure_db_dir
        puts Util.db_path
        Util.save_config({db_name: name_with_ext})
        puts "#{name_with_ext} successfully created."
      end
    end
    # TODO define next command
    desc "generate SCHEMA_NAME TABLE1 TABLE2 ... ", "Create a blank schema file to be edited"
    long_desc <<-GENERATE
    Create a blank schema file called schema.rb. In it you can use the OpalORM
    DSL to create tables with different datatypes.
    Then create the schema with ``.
    You may optionally pass the table names that you want to create. Otherwise you
    will have to add them yourself.
    GENERATE

    def generate(file_name, *table_names)
      OpalORM::SchemaManager.generate(file_name, *table_names)
    rescue FileExistsError => e
      puts e.message
      puts "Aborting."
    rescue ForeignKeyMissingError => e
      puts e.message
      puts "Aborting."
    end
  end

end
