module DatesHelper
  def display_date(date)
    return "N/A" unless date.present?
    date.in_time_zone("Buenos Aires").strftime("%d/%m/%Y")
  end
end
