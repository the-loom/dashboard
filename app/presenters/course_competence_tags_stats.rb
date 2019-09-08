class CompetenceTagsStats

  attr_reader :values

  def initialize(competable)
    @values = Hash[CompetenceTag.all.map { |c| [c.name, 0] }]

    competable.events.group_by do |event|
      event.competence_tag
    end.each do |group, events|
      @values[group.name] = events.inject(0) do |total_points, event|
        total_points + event.points
      end
    end
  end

end
