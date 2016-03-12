require_relative 'util'
require_relative 'query_builder'
module OpalORM
  class SchemaManager
    Util.ensure_db_dir

    def self.test
      puts "test"
    end

    def self.generate(file_name, *table_names)
      schema_path = File.join(Util.db_path, "#{file_name}.rb")
      if File.exist?(schema_path)
        raise FileExistsError, "#{file_name}.rb already exists. Please choose a different filename."
      else
        puts "Creating file 'db/schema.rb' ..."
        File.open(schema_path, "w+") do |f|
          contents = []
          if table_names.empty?
            contents << <<-RB
              OpalORM::SchemaManager.create_table("table_name") do |t|
              end
            RB
          else
            contents += table_names.map do |table_name|
              puts "adding table #{table_name} ..."
              <<-RB
SchemaManager.create_table \'#{table_name}\' do |t|

end

              RB
          end
            contents.unshift(<<-RB)
# Example usage:
# SchemaManager.create_table 'table_name' do |t|
#   t.string column_name
# end
#
# The primary key will be created automatically, with name 'id'.
            RB
          end
          p contents
          f.write(contents.join)
          puts "Done."
        end
      end
    end

    def self.create_table(table_name, &prc)
      puts QueryBuilder.create_table_query(table_name, &prc)
    end

  end

  class FileExistsError < StandardError
  end
end
