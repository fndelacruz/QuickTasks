class Task < SQLObject
  belongs_to :user, foreign_key: :owner_id

  def to_s
    content
  end

  def complete?
    complete == 1
  end

  def toggle_complete!
    self.complete = complete? ? 0 : 1
    save
  end
end
