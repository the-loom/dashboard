class Timer < ApplicationRecord

  enum stage: {
      analysis: 0,
      test_preparation: 1,
      design: 2,
      coding: 3,
      text_execution: 4
  }

  belongs_to :solution

  default_scope { order(id: :asc) }

  def running?
    started_at != nil
  end

  def play
    return if running?

    self.started_at = Time.zone.now
  end

  def pause
    return unless running?
    now = Time.zone.now
    self.total_time_in_seconds = 0 if self.total_time_in_seconds == nil
    self.total_time_in_seconds += now - self.started_at
    self.started_at = nil
  end

end
