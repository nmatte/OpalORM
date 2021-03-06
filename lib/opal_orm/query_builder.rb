require 'active_support/inflector'

module OpalORM
  class QueryBuilder
    DATATYPES = {
    string: "VARCHAR(255)",
    integer: "INTEGER",
    float: "REAL",
    text: "TEXT"
    }

    def self.create_table_query(name, &prc)
      manager = new(name)
      prc.call(manager)

      manager.build!
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

    def float(name, *options)
      @columns << {type: :float, name: name, options: options}
    end

    def text(name, *options)
      @columns << {type: :text, name: name, options: options}
    end

    # def foreign_key(ref_name)
    #   @foreign_keys << ref_name
    # end

    def build!
      query_start = "CREATE TABLE #{@table_name} ("
      
      column_queries = @columns.map do |col_info|
        result = ["#{col_info[:name]}"]
        result << get_datatype_string(col_info[:type])

        unless col_info[:options].nil?
          col_info[:options].each do |key|
            case col_info[:options]
            when :null
              result << "NOT NULL" unless col_info[:options][:null]
            end
          end
        end

        result.join(" ")
      end
      column_queries.unshift("id INTEGER PRIMARY KEY")

      foreign_keys = @foreign_keys.map do |ref_name|
        if foreign_key_valid?(ref_name)
          "FOREIGN KEY(#{ref_name}) REFERENCES #{@table_name.singularize}(id)"
        else
          raise ForeignKeyMissingError, "Error adding foreign key constraint for #{ref_name}: couldn't find column named #{ref_name}."
        end
      end

      query_end = ");"

      @query = query_start + column_queries.concat(foreign_keys).join(",\n") + query_end
      @query
    end

    def get_datatype_string(type)
      DATATYPES[type]
    end

    def foreign_key_valid?(key)
      @columns.any? {|col| key == col[:name]}
    end
  end

  class ForeignKeyMissingError < StandardError
  end

  class DatatypeMissingError < StandardError
  end
end
