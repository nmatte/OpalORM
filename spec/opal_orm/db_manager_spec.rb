require_relative '../../lib/opal_orm/query_builder.rb'
require 'active_support/inflector'
describe 'OpalORM::QueryBuilder' do
  describe '::create_table' do
    it 'creates the correct query for integers' do
      table_name = "test_table"
      col_name = "integer_column"
      query = OpalORM::QueryBuilder.create_table_query(table_name) do |t|
        t.integer col_name
      end

      expect(remove_whitespace(query)).to eq(remove_whitespace(<<-SQL))
        CREATE TABLE #{table_name} (
          id INTEGER PRIMARY KEY,
          #{col_name} INTEGER
        );
      SQL
    end

    it 'creates the correct query for strings' do
      table_name = "test_table"
      col_name = "integer_column"
      query = OpalORM::QueryBuilder.create_table_query(table_name) do |t|
        t.string col_name
      end

      expect(remove_whitespace(query)).to eq(remove_whitespace(<<-SQL))
        CREATE TABLE #{table_name} (
          id INTEGER PRIMARY KEY,
          #{col_name} VARCHAR(255)
        );
      SQL
    end

    it 'creates the correct query for foreign keys' do
      table_name = "test_table"
      col_name = "integer_column"
      query = OpalORM::QueryBuilder.create_table_query(table_name) do |t|
        t.string col_name

        t.foreign_key col_name
      end

      expect(remove_whitespace(query)).to eq(remove_whitespace(<<-SQL))
        CREATE TABLE #{table_name} (
          id INTEGER PRIMARY KEY,
          #{col_name} VARCHAR(255),
          FOREIGN KEY(#{col_name}) REFERENCES #{table_name.singularize}(id)
        );
      SQL
    end
  end
end

def remove_whitespace(str)
  str.delete(" ").delete("\n").downcase
end
