class StudentCompetenceTagsStats

  attr_reader :values

  def initialize(user)
    @values = Hash[CompetenceTag.all.map { |c| [c.name, 0] }]

    user.events.group_by do |event|
      event.competence_tag
    end.each do |group, events|
      @values[group.name] = events.inject(0) do |total_points, event|
        total_points + event.points
      end
    end

    @values["Perseverancia"] = Attendance.where(user: user, condition: :present).count * 10
  end

  def normalized
    baseline = CourseCompetenceTagsStats.new.values
    @values.map do |key, value|
      divisor = baseline[key] == 0 ? ( value == 0 ? 1 : value ) : baseline[key]
      { axis: key, value: value / divisor.to_f }
    end
  end

  def present
    @values.map do |key, value|
      { axis: key, value: value }
    end
  end

end
