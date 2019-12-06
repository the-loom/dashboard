class StudentCompetenceTagsStats < CompetenceTagsStats

  def initialize(user)
    @values = Hash.new(0)

    user.occurrences.group_by do |occurrence|
      occurrence.event.competence_tag
    end.each do |group, occurrences|
      @values[group.name] = occurrences.inject(0) do |total_points, occurrence|
        total_points + occurrence.total_points
      end
    end
  end
end
