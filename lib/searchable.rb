module Searchable
  def where(params)
    where_string = params.map { |k,_| "#{k} = ?" }.join(" AND ")
    values = params.values
    results = DBConnection.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_string}
    SQL
    parse_all(results)
  end
end
