class User < SQLObject
  finalize!

  has_many :cats, foreign_key: :owner_id

  def to_s
    "#{fname} #{lname}"
  end
end
