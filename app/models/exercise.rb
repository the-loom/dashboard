class Exercise < ApplicationRecord
  include CourseLock
  include Publishable
  include HasDifficulty

  validates_presence_of :name, :notes
  validates :name, uniqueness: { scope: :course_id }

  default_scope { order(name: :asc) }
end
