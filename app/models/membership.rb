class Membership < ApplicationRecord
  belongs_to :course
  belongs_to :user

  belongs_to :team, optional: true

  scope :enabled, -> { joins(:course).where(courses: { enabled: true }) }

  enum role: {
    guest: 0,
    student: 1,
    teacher: 2,
    admin: 3
  }

  def level
    Level.new(points, user.badges.size).value
  end

  def add_points(value)
    self.points += value
    self.save!
  end

  def read_notifications
    self.unread_notifications = 0
    self.save!
  end
end
