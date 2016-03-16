require_relative 'db_connection'
require_relative 'sql_object'
module OpalORM
  module Searchable
    def where(params)
      where_clause = params.keys.map do |key|
        "#{key.to_s} = ?"
      end.join(" AND ")
      results = DBConnection.execute(<<-SQL,params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_clause}
      SQL
      results.map { |res| new(res)}
    end
  end
end

class OpalORM::SQLObject
  extend OpalORM::Searchable
end
