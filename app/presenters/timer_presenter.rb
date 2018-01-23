class TimerPresenter
  def initialize(timer)
    @timer = timer
  end

  def to_json
    {
        id: @timer.id,
        stage_id: @timer.read_attribute_before_type_cast(:stage),
        now: Time.zone.now.to_i,
        started_at: @timer.started_at.to_i,
        estimated_time_in_seconds: @timer.estimated_time_in_seconds,
        total_time_in_seconds: @timer.total_time_in_seconds
    }
  end
end
