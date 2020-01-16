class Occurrence < ApplicationRecord
  include CourseLock

  belongs_to :user
  belongs_to :event

  default_scope { order(created_at: :asc) }

  def total_points
    event.points * multiplier
  end
end
