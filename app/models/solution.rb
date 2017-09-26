class Solution < ApplicationRecord
  belongs_to :exercise

  has_many :timers, dependent: :destroy

  has_many :user_solutions
  has_many :users, through: :user_solutions

  def finished?
    self.finished_at != nil
  end

end
