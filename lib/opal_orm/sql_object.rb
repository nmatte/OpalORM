require_relative 'db_connection'
require 'active_support/inflector'

module OpalORM
  class SQLObject
    def self.columns
      @cols ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
        SELECT
          *
        FROM
          #{table_name}
      SQL
    end

    def self.finalize!
      columns.each do |col_sym|
        define_method(col_sym) do
          attributes[col_sym]
        end
        define_method("#{col_sym}=") do |new_val|
          attributes[col_sym] = new_val
        end
      end
    end

    def self.table_name=(table_name)
      @table_name = table_name
    end

    def self.table_name
      @table_name ||= self.to_s.downcase.pluralize
    end

    def self.all
      objs = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL
      parse_all(objs)
    end

    def self.parse_all(results)
      objs = []
      results.each do |obj|
        objs << new(obj)
      end
      objs
    end

    def self.find(id)
      result = DBConnection.execute(<<-SQL,id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
      SQL
      return nil if result.empty?
      new(result.first)
    end

    def initialize(params = {})
      params.each do |attribute,val|
        col_sym = attribute.to_sym
        if self.class.columns.include?(col_sym)
          self.send("#{col_sym}=",val)
        else
          raise "unknown attribute '#{attribute}'"
        end
      end
    end

    def attributes
      @attributes ||= {}
    end

    def attribute_values
      self.class.columns.map do |col|
        attributes[col]
      end
    end

    def insert
      columns = self.class.columns#.reject { |c| c.nil?}
      cols = columns.join(", ")
      placeholders = (["?"] * columns.length).join(", ")
      DBConnection.execute(<<-SQL,*attribute_values)
      INSERT INTO
        #{self.class.table_name}(#{cols})
      VALUES
        (#{placeholders})
      SQL
      attributes[:id] = DBConnection.last_insert_row_id
    end

    def update
      cols = self.class
        .columns
        .map { |col_name| "#{col_name} = ?"}
        .join(", ")
      DBConnection.execute(<<-SQL,*attribute_values - [:id], id)
      UPDATE
        #{self.class.table_name}
      SET
        #{cols}
      WHERE
        id = ?
      SQL
    end

    def save
      id.nil? ? insert : update
    end
  end
end
