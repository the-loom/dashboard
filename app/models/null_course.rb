class NullCourse
  def nil?
    true
  end

  def on?(_requested_feature)
    false
  end

  def template?
    false
  end
end
