module DatesHelper
  def display_date(date)
    return "N/A" unless date.present?
    date.in_time_zone("Buenos Aires").strftime("%d/%m/%Y")
  end

  def display_time(time)
    return "N/A" unless time.present?
    time.in_time_zone("Buenos Aires").strftime("%H:%M")
  end

  def display_time_range(time_from, time_to)
    return "N/A" unless time_from.present? && time_to.present?
    "#{display_time time_from} a #{display_time time_to}"
  end
end
