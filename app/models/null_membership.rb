class NullMembership
  def save! ; end

  def unread_notifications
    0
  end

  def unread_notifications=(_value) ; end

  def team
    nil
  end

  def enabled?
    false
  end

  def admin?
    false
  end

  def teacher?
    false
  end

  def student?
    false
  end

  def present_at_lecture_ids
    []
  end

  def nil?
    true
  end

  def points
    0
  end
end
