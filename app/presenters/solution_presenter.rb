class SolutionPresenter

  def initialize(solution)
    @solution = solution
  end

  def to_json
    stages = []
    @solution.timers.each { |timer|
      stages << {
          id: timer.read_attribute_before_type_cast(:stage),
          name: I18n.t("timers.stages.#{timer.stage}"),
          estimated_time_in_seconds: timer.estimated_time_in_seconds,
          total_time_in_seconds: timer.total_time_in_seconds,
          started_at: timer.started_at.to_i,
          running: timer.started_at != nil
      }
    }

    {
        solution_id: @solution.id,
        now: Time.zone.now.to_i,
        stages: stages
    }
  end
end
