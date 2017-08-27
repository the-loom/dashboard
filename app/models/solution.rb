class Solution < ApplicationRecord
  belongs_to :exercise
  belongs_to :user

  has_many :timers, dependent: :destroy

  def finished?
    self.finished_at != nil
  end

  def prepare_timers!
    Timer.stages.each { |stage|
      timers << Timer.new(stage: stage[1])
    }
    save!
  end

end
