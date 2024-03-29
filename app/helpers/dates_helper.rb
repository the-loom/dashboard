module DatesHelper
  DAYNAMES = %w(Domingo Lunes Martes Miércoles Jueves Viernes Sábado)

  def display_date(date)
    return "N/A" unless date.present?
    date.in_time_zone("Buenos Aires").strftime("%d/%m/%Y")
  end

  def display_invisible_date(date)
    return "" unless date.present?
    date.in_time_zone("Buenos Aires").strftime("%Y%m%d")
  end

  def display_day(wday)
    DAYNAMES[wday]
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
