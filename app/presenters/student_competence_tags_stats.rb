class StudentCompetenceTagsStats < CompetenceTagsStats
  def initialize(student)
    @values = Hash.new(0)
    return unless student.enabled?

    student.occurrences.joins(:event).where.not({ occurrences: { events: { competence_tag: nil } } }).group_by do |occurrence|
      occurrence.event.competence_tag
    end.each do |competence, occurrences|
      @values[competence.name] = occurrences.inject(0) do |total_points, occurrence|
        total_points + occurrence.total_points
      end
    end
  end
end
