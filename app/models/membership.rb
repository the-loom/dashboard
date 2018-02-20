class Membership < ApplicationRecord
  belongs_to :course
  belongs_to :user

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
end
