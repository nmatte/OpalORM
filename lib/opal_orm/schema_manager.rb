require_relative 'util'
require_relative 'query_builder'

module OpalORM
  class SchemaManager
    Util.ensure_db_dir

    def self.test
      puts "test"
    end

    def self.generate(file_name, *table_names)
      puts "are you seeing this"
      puts Util.db_path
      schema_path = File.join(Util.db_path, "#{file_name}.rb")
      puts schema_path
      if File.exist?(schema_path)
        raise FileExistsError, "#{file_name}.rb already exists. Please choose a different filename."
      else
        puts "Creating file 'db/#{file_name}.rb' ..."
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
              create_table_from_name(table_name)
          end
            contents.unshift(comment_string)
          end
          puts contents
          f.write(contents.join)
          puts "Done."
        end
      end
    end

    def self.create_table_from_name(table_name)
      <<-RB
SchemaManager.create_table \'#{table_name}\' do |t|

end
      RB
    end

    def comment_string
      <<-RB
# Example usage:
# SchemaManager.create_table 'table_name' do |t|
#   t.string column_name
# end
#
# The primary key will be created automatically, with name 'id'.
      RB
    end

    def self.create_table(table_name, &prc)
      q = QueryBuilder.create_table_query(table_name, &prc)

    end

  end

  class FileExistsError < StandardError
  end
end
