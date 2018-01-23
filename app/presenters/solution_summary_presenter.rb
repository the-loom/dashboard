class SolutionSummaryPresenter
  attr_reader :by_stage, :totals

  def initialize solution
    @solution = solution

    @by_stage = solution.timers.sort_by { |t| t.read_attribute_before_type_cast(:stage) }.collect { |timer|
      {
          stage: timer.stage.to_sym,
          description: timer.description,
          estimated_time_in_seconds: timer.estimated_time_in_seconds || 0,
          total_time_in_seconds: timer.total_time_in_seconds || 0,
          delta_over_estimated_time: (timer.total_time_in_seconds || 0) - (timer.estimated_time_in_seconds || 0),
          delta_percentage: (timer.total_time_in_seconds || 0) == 0 ? 0 : (((timer.total_time_in_seconds || 0) - (timer.estimated_time_in_seconds || 0)) * 100) / (timer.estimated_time_in_seconds || 0)
      }
    }

    @totals = {
        estimated_grand_total_in_seconds: solution.timers.sum { |t| t.estimated_time_in_seconds.to_i },
        grand_total_in_seconds: solution.timers.sum { |t| t.total_time_in_seconds.to_i },
        delta_over_estimated_grand_total: solution.timers.sum { |t| t.total_time_in_seconds.to_i } - solution.timers.sum { |t| t.estimated_time_in_seconds.to_i },
        delta_percentage: (solution.timers.sum { |t| t.estimated_time_in_seconds.to_i }) == 0 ? 0 : (solution.timers.sum { |t| t.total_time_in_seconds.to_i } - solution.timers.sum { |t| t.estimated_time_in_seconds.to_i }) * 100 / solution.timers.sum { |t| t.estimated_time_in_seconds.to_i }
    }
  end

  def times_for(stage)
    @by_stage.find { |d|
      d[:stage] == stage
    }
  end
end
