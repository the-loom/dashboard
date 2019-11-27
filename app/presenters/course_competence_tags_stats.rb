class CourseCompetenceTagsStats < CompetenceTagsStats
  attr_reader :values

  def initialize(course)
    @values = Hash.new(0)

    individual_stats = course.users.
        includes(:occurrences).
        includes(:events).
        includes(occurrences: { event: :competence_tag }).
        map do |student|
      nil unless student.enabled?
      StudentCompetenceTagsStats.new(student)
    end.compact

    CompetenceTag.all.each do |competence|
      points = individual_stats.map { |stat| stat.values[competence.name] }
      @values[competence.name] = points.sum / individual_stats.size
    end
  end
end
