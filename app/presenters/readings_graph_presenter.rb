class ReadingsGraphPresenter
  attr_reader :readings

  def initialize(measurements)
    @dates = measurements.collect { |m| m.created_at.beginning_of_day }.uniq
    @readings = measurements.collect(&:reading).uniq
    @measurements_by_reading = {}
    @readings.each do |r|
      ms = []
      @dates.each do |d|
        ms << measurements.detect { |mm| mm.reading == r && mm.created_at.beginning_of_day == d }
      end
      @measurements_by_reading[r] = ms
    end
  end

  def c3_dates_row
    "['x', '#{@dates.collect { |d| d.strftime('%F') }.join('\', \'')}']"
  end

  def c3_data_rows
    rows = []
    @measurements_by_reading.each do |reading, measurements|
      rows << "['#{reading.slug}', #{measurements.collect { |m| m ? m.value : 'null' }.join(', ')}]"
    end
    rows.join(",\n")
  end
end
