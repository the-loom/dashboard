class CompetenceTagsStats
  attr_reader :values

  def initialize
    @values = Hash.new(0)

    Event.all.includes(:competence_tag).group_by do |event|
      event.competence_tag
    end.each do |group, events|
      @values[group.name] = events.inject(0) do |total_points, event|
        total_points + event.max_points
      end
    end
  end

  def normalized
    baseline = CompetenceTagsStats.new.values
    @values.sort.map do |key, value|
      divisor = baseline[key] == 0 ? ( value == 0 ? 1 : value ) : baseline[key]
      { axis: key, value: [value / divisor.to_f, 1].min.round(2) }
    end
  end
end
