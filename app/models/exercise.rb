class Exercise < ApplicationRecord
  include CourseLock

  has_many :solutions

  default_scope { order(name: :asc) }

  def active_solution_for?(user)
    solutions.detect { |solution| !solution.finished? && solution.users.include?(user) }
  end
end
