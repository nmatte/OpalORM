module OpalORM
  class SchemaManager
    CURRENT_PATH = Dir.pwd
    DB_PATH = File.join(CURRENT_PATH, 'db')

    def self.generate(file_name, *table_names)
      schema_path = File.join(DB_PATH, "#{file_name}.rb")
      if File.exist?(schema_path)
        raise FileExistsError, "#{name}.rb already exists. Please choose a different filename."
      else
        File.open(schema_path, "w+") do |f|
          contents = ""
          if table_names.empty?
            contents = <<-RB
              SchemaManager.create_table("table_name") do |t|
              end
            RB
          else
            contents = table_names.map do |table_name|
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
          f.write(contents.join)
        end
      end
    end

  end

  class FileExistsError < StandardError
  end
end
