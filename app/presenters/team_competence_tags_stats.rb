class TeamCompetenceTagsStats < CompetenceTagsStats

  def initialize(team)
    @values = Hash.new(0)

    individual_stats = team.enabled_members.map do |student|
      StudentCompetenceTagsStats.new(student)
    end

    CompetenceTag.all.each do |competence|
      points = individual_stats.map { |stat| stat.values[competence.name] }
      @values[competence.name] = points.sum / team.enabled_members.size
    end
  end
end
