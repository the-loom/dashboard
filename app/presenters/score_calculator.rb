class ScoreCalculator

  attr_reader :min_points, :max_points

  def initialize
    @min_points = Event.min_points
    @max_points = Event.max_points
  end

  def score_for(points)
    spread = @max_points - @min_points
    normalized = points - @min_points
    if points < @min_points
      2.0
    elsif points >= @max_points
      10.0
    else
      (normalized.to_f / spread) * 6 + 4
    end
  end

end
