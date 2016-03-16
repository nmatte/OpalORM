require_relative 'db_connection'
require 'active_support/inflector'

module OpalORM
  class SQLObject
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

    def self.columns
      @cols ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
      SELECT
      *
      FROM
      #{table_name}
      SQL
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

    def self.finalize!
      columns.each do |col_sym|
        define_getter(col_sym)
        define_setter(col_sym)
      end
    end

    def self.define_getter(attr_name)
      define_method(attr_name) do
        attributes[attr_name]
      end
    end

    def self.define_setter(attr_name)
      define_method("#{attr_name}=") do |new_val|
        attributes[attr_name] = new_val
      end
    end

    def self.table_name=(table_name)
      @table_name = table_name
    end

    def self.table_name
      @table_name ||= self.to_s.downcase.pluralize
    end

    def self.all
      query = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
      SQL
      objs = DBConnection.execute(query)
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

    def attributes
      @attributes ||= {}
    end

    def attribute_values
      self.class.columns.map do |col|
        attributes[col]
      end
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

    def self.is_column?(col_sym)
      self.columns.include?(col_sym)
    end

    def method_missing(method_sym, *args)
      if self.class.is_column?(method_sym)
        self.class.define_getter(method_sym)
        return send(method_sym)
      end

      setter_name = /(.*)=/.match(method_sym)
      if setter_name && self.class.is_column?(setter_name[1].to_sym)
        self.class.define_setter(setter_name[1].to_sym)
        p method_sym
        send(method_sym, args[0])
      else
        super(method_sym, args)
      end
    end
  end
end
