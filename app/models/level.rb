class Level
  def initialize(points, badges)
    @points = points
    @badges = badges
  end

  def value
    assets = @points + @badges * 5
    v = 0 if assets == 0
    v = 1 if assets > 0
    v = 2 if assets > 30
    v = 3 if assets > 65
    v = 4 if assets > 100
    v = 5 if assets > 135
    v
  end
end
