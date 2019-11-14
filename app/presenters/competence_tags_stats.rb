class CompetenceTagsStats
  attr_reader :values

  def normalized
    baseline = CourseCompetenceTagsStats.new.values
    @values.sort.map do |key, value|
      divisor = baseline[key] == 0 ? ( value == 0 ? 1 : value ) : baseline[key]
      { axis: key, value: [value / divisor.to_f, 1].min.round(2) }
    end
  end
end
