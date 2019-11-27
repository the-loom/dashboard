class StudentCompetenceTagsStats < CompetenceTagsStats

  def initialize(user)
    @values = Hash.new(0)

    user.events.includes(:competence_tag).group_by do |event|
      event.competence_tag
    end.each do |group, events|
      @values[group.name] = events.inject(0) do |total_points, event|
        total_points + event.points
      end
    end
  end
end
