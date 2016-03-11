require 'thor'
require_relative 'query_builder'
require_relative 'db_connection'
require_relative 'schema_manager'

module OpalORM
  class DatabaseManager < Thor
    # desc "hello NAME", "This will greet you"
    # long_desc <<-HELLO_WORLD
    #
    # `hello NAME` will print out a message to the person of your choosing.
    #
    # Brian Kernighan actually wrote the first "Hello, World!" program
    # as part of the documentation for the BCPL programming language
    # developed by Martin Richards. BCPL was used while C was being
    # developed at Bell Labs a few years before the publication of
    # Kernighan and Ritchie's C book in 1972.
    #
    # http://stackoverflow.com/a/12785204
    # HELLO_WORLD
    # option :upcase
    # def hello( name )
    #   greeting = "Hello, #{name}"
    #   greeting.upcase! if options[:upcase]
    #   puts greeting
    # end

    desc "create DATABASE_NAME", "Create the database to be used by OpalORM"
    long_desc <<-CREATE
    Create an empty database in the current directory with the name
    provided, and save the database name to db/opal_config.json.
    CREATE

    def create(name)
      DBConnection.open("#{name}.db")
    end

    desc "generate TABLE1 TABLE2 ... ", "Create a blank schema file to be edited"
    long_desc <<-CREATE
    Create a blank schema file called schema.rb. In it you can use the OpalORM
    DSL to create tables with different datatypes.
    Then create the schema with `db make`.
    You may optionally pass the table names that you want to create. Otherwise you
    will have to add them yourself.
    CREATE

    def generate(file_name, *table_names)
      OpalORM::SchemaManager.generate(file_name, *table_names)
    end
  end

end
