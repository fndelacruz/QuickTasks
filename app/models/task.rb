class Task < SQLObject
  finalize!

  belongs_to :user, foreign_key: :owner_id

  def to_s
    content
  end
end
