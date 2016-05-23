require_relative 'db_connection'

class ActiveRecordLite_Relation

  def initialize(array)
    @array = array
  end

  # assumes all members are of same class as first element in @array
  def delete
    return if empty?
    table_name = @array[0].class.table_name
    ids = @array.map(&:id)
    id_string = "(#{ids.join(", ")})"
    where_string = "id IN #{id_string}"
    DBConnection.execute(<<-SQL)
      DELETE FROM
        #{table_name}
      WHERE
        #{where_string}
    SQL
  end

  def [](idx)
    @array[idx]
  end

  def count(&blk)
    poop = @array.reduce(0) do |sum, el|
      yield(el) ? sum + 1 : sum
    end
  end

  def length
    @array.length
  end

  def empty?
    length == 0
  end

  def each(&blk)
    @array.each do |el|
      yield(el)
    end
    self
  end

  def to_a
    @array
  end
end
