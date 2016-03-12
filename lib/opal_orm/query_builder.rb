module OpalORM
  class QueryBuilder
    def self.create_table_query(name, &prc)
      manager = new(name)
      prc.call(manager)
      manager.finalize!
    end

    attr_reader :query

    def initialize(name)
      @table_name = name
      @columns = []
      @foreign_keys = []
    end

    def string(name, *options)
      @columns << {type: :string, name: name, options: options}
    end

    def integer(name, *options)
      @columns << {type: :integer, name: name, options: options}
    end

    def finalize!
      queryStart = "CREATE TABLE #{@table_name} ("

      columnQueries = @columns.map do |colInfo|
        result = ""
        case colInfo[:type]
        when :string
          result = "#{colInfo[:name]} VARCHAR(255) "
        when :integer
          result = "#{colInfo[:name]} INTEGER "
        end

        result
      end
      queryEnd = ");"

      @query = queryStart + columnQueries.join("\n") + queryEnd
    end
  end
end
