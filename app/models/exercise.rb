class Exercise < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :url
  validates :name, uniqueness: { scope: :course_id }

  has_many :solutions

  default_scope { order(name: :asc) }

  def active_solution_for?(user)
    solutions.detect { |solution| !solution.finished? && solution.users.include?(user) }
  end
end
