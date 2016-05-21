require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'

class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    # NB: may have issues reflecting database columns when delete/add columns
    @columns ||= DBConnection.execute2("
      SELECT
        *
      FROM
        #{table_name}
    ").first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |attribute|
      define_method(attribute) { attributes[attribute] }
      define_method("#{attribute}=") { |val| attributes[attribute] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| new(result) }
  end

  def self.find(id)
    raise "find argument must be an integer." if id.to_i == 0 && id != '0'

    id = id.to_i
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL
    result.empty? ? nil : new(result.first)
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      debugger if attr_name == 3
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        send("#{attr_name}=", value)
      else
        try("#{attr_name}=", value)
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attributes.values
  end

  def insert
    column_string = self.class.columns[1..-1].join(", ")
    question_marks_string =
      ("?" * (self.class.columns.length - 1)).split("").join(", ")
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{column_string})
      VALUES
        (#{question_marks_string})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def non_id_columns
    self.class.columns.reject { |column| column == :id }
  end

  def update(params)
    raise "no id provided" unless id
    params.each do |attr_name, value|
      send("#{attr_name}=", value)
    end
    save
  end

  def sql_update
    raise "no id provided" unless id
    set_string = non_id_columns.map { |col| "#{col} = ?" }.join(", ")
    values = attributes.values_at(*non_id_columns) << id
    DBConnection.execute(<<-SQL, *values)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_string}
      WHERE
        id = ?
    SQL
  end

  def save
    id ? sql_update : insert
  end
end
