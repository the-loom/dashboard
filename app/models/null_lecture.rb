class NullLecture
  def time_from
    Time.zone.now.at_beginning_of_hour
  end

  def time_to
    Time.zone.now.at_beginning_of_hour + 4.hours
  end
end
