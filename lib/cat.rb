require_relative 'sql_object'

class Cat < SQLObject
  finalize!

  def to_s
    self.name
  end
end
