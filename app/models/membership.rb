class Membership < ApplicationRecord
  include Discard::Model

  serialize :present_at_lecture_ids, JSON

  belongs_to :course
  belongs_to :user

  belongs_to :team, optional: true

  default_scope -> { kept }
  scope :enabled, -> { joins(:course).where(courses: { enabled: true }) }

  delegate :admin?, to: :user

  enum role: {
    student: 1,
    teacher: 2
  }

  def read_notifications
    self.unread_notifications = 0
    self.save!
  end
end
