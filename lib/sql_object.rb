# require 'active_support/inflector'
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
        raise "unknown attribute '#{attr_name}'"
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

  def update
    raise "no id provided" unless id
    set_string = self.class.columns[1..-1].map { |col| "#{col} = ?" }.join(", ")
    values = attribute_values[1..-1] << id
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
    id ? update : insert
  end
end
