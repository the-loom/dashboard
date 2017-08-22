class Solution < ApplicationRecord
  belongs_to :exercise
  belongs_to :user

  has_many :timers, table_name: :exercise_timers
end
