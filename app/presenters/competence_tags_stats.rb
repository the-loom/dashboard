class CompetenceTagsStats
  attr_reader :values

  def initialize
    @values = Hash.new(0)

    Event.enabled.includes(:competence_tag).group_by(&:competence_tag).each do |group, events|
      next unless group
      @values[group.name] = events.inject(0) do |total_points, event|
        total_points + event.max_points
      end
    end
  end

  def normalized
    CompetenceTagsStats.new.values.sort.map do |key, base_value|
      actual_value = @values[key]
      divisor = base_value == 0 ? (actual_value == 0 ? 1 : actual_value) : base_value
      { axis: key, value: [actual_value / divisor.to_f, 1].min.round(2) }
    end
  end
end
