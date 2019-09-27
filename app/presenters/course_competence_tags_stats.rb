class CourseCompetenceTagsStats
  attr_reader :values

  def initialize
    @values = Hash[CompetenceTag.all.map { |c| [c.name, 0] }]

    Event.all.group_by do |event|
      event.competence_tag
    end.each do |group, events|
      @values[group.name] = events.inject(0) do |total_points, event|
        total_points + event.max_points
      end
    end
  end
end
