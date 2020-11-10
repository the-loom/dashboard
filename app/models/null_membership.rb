class NullMembership
  def unread_notifications
    0
  end

  def team
    nil
  end

  def enabled?
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
end
