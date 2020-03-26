class Exercise < ApplicationRecord
  include CourseLock
  include Publishable

  validates_presence_of :name, :notes, :difficulty
  validates :name, uniqueness: { scope: :course_id }
  validates :difficulty, inclusion: { in: 1..5, message: "must be between 1 and 5" }

  default_scope { order(name: :asc) }
end
