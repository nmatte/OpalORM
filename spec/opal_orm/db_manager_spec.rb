require_relative '../../lib/opal_orm/query_builder.rb'

describe 'QueryBuilder' do
  describe '::create_table' do
    it 'creates the correct query for integers' do
      table_name = "test_table"
      col_name = "integer_column"
      query = QueryBuilder.create_table_query(table_name) do |t|
        t.integer col_name
      end

      expect(remove_whitespace(query)).to eq(remove_whitespace(<<-SQL))
        CREATE TABLE #{table_name} (
          #{col_name} INTEGER
        );
      SQL
    end

    it 'creates the correct query for strings' do
      table_name = "test_table"
      col_name = "integer_column"
      query = QueryBuilder.create_table_query(table_name) do |t|
        t.string col_name
      end

      expect(remove_whitespace(query)).to eq(remove_whitespace(<<-SQL))
        CREATE TABLE #{table_name} (
          #{col_name} VARCHAR(255)
        );
      SQL
    end
  end
end

def remove_whitespace(str)
  str.delete(" ").delete("\n").downcase
end
