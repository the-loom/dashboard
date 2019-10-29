class StudentCompetenceTagsStats
  attr_reader :values

  def initialize(user)
    @values = Hash.new(0)

    user.events.group_by do |event|
      event.competence_tag
    end.each do |group, events|
      @values[group.name] = events.inject(0) do |total_points, event|
        total_points + event.points
      end
    end
  end

  def normalized
    baseline = CourseCompetenceTagsStats.new.values
    @values.map do |key, value|
      divisor = baseline[key] == 0 ? ( value == 0 ? 1 : value ) : baseline[key]
      { axis: key, value: [value / divisor.to_f, 1].min }
    end
  end

  def present
    @values.map do |key, value|
      { axis: key, value: value }
    end
  end
end
