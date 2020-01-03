class TeamCompetenceTagsStats < CompetenceTagsStats

  def initialize(team)
    @values = Hash.new(0)

    individual_stats = team.enabled_members.map do |student|
      StudentCompetenceTagsStats.new(student)
    end

    CompetenceTag.all.each do |competence|
      points = individual_stats.map { |stat| stat.values[competence.name] }
      if team.enabled_members.size > 0
        @values[competence.name] = points.sum / team.enabled_members.size
      else
        @values[competence.name] = 0
      end
    end
  end
end
