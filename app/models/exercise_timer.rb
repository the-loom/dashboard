class ExerciseTimer < ApplicationRecord

  enum stage: {
      analysis: 0,
      test_preparation: 1,
      design: 2,
      coding: 3,
      text_execution: 4
  }

  belongs_to :solution

  def running?
    started_at != nil
  end

  def start
    self.started_at = Time.zone.now
  end

  def pause
    now = Time.zone.now
    self.total_time_in_milliseconds = 0 if self.total_time_in_milliseconds == nil
    self.total_time_in_milliseconds += now - self.started_at
    self.started_at = nil
  end

end
