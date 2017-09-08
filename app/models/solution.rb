class Solution < ApplicationRecord
  belongs_to :exercise

  has_many :timers, dependent: :destroy

  has_many :user_solutions
  has_many :users, through: :user_solutions

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
