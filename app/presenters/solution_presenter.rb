class SolutionPresenter

  def initialize(solution)
    @solution = solution
  end

  def to_json
    {
        solution_id: @solution.id,
        now: Time.zone.now.to_i,
        stages: Timer.stages.map do |name, id|
          {
              id: id,
              description: I18n.t("timers.stages.#{name}"),
              timers: @solution.timers.where(stage: name.to_sym).map do |timer|
                {
                    id: timer.id,
                    estimated_time_in_seconds: timer.estimated_time_in_seconds,
                    total_time_in_seconds: timer.total_time_in_seconds,
                    started_at: timer.started_at.to_i,
                    running: timer.started_at != nil,
                    description: timer.description
                }
              end
          }
        end
    }
  end
end
