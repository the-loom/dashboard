class Membership < ApplicationRecord
  include Discard::Model

  belongs_to :course
  belongs_to :user

  belongs_to :team, optional: true

  default_scope -> { kept }
  scope :enabled, -> { joins(:course).where(courses: { enabled: true }) }

  enum role: {
    student: 1,
    teacher: 2,
    admin: 3
  }

  def add_points(value)
    self.points += value
    self.save!
  end

  def read_notifications
    self.unread_notifications = 0
    self.save!
  end
end
