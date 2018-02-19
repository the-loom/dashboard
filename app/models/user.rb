class User < ApplicationRecord
  validates_presence_of :name

  has_many :memberships
  has_many :courses, through: :memberships

  has_many :identities

  has_many :occurrences, -> { order(created_at: :desc) }
  has_many :events, through: :occurrences

  has_many :earnings, -> { order(created_at: :desc) }
  has_many :badges, through: :earnings

  has_many :attendances
  has_many :lectures, through: :attendances

  has_many :comments

  has_many :user_solutions
  has_many :solutions, through: :user_solutions

  belongs_to :team, optional: true

  delegate :points, to: :current_membership
  delegate :level, to: :current_membership

  delegate :admin?, to: :current_membership

  def update_with(identity)
    self.nickname = identity.nickname
    self.name = identity.name
    self.email = identity.email
    self.image = identity.image
    self.save
    self
  end

  def current_membership
    self.memberships.find_by(course: Course.current)
  end

  def teacher?
    current_membership.teacher? || current_membership.admin?
  end

  def student?
    current_membership.student?
  end

  def guest?
    current_membership.guest?
  end

  def unregister_attendance(lecture)
    if attendances.detect { |a| a.present? && a.lecture == lecture }
      current_membership.add_points(-10)
    end
    Attendance.find_by(user: self, lecture: lecture).try(:delete)
  end

  def register_attendance(lecture, condition)
    if condition == :present
      current_membership.add_points(10)
    end
    attendances.create(lecture: lecture, condition: condition)
  end

  def register(event)
    events_count = events.count { |x| x.name == event.name } + 1
    if events_count % event.batch_size == 0
      points_per_event = event.points_per_batch
    else
      points_per_event = 0
    end
    occurrences.create(event: event, points: points_per_event)
    current_membership.add_points(points_per_event)
    self.save!
  end

  def earn(badge)
    earnings.create(badge: badge)
  end

  def self.sorted
    self.order(points: :desc)
  end

  def self.sorted_by_name
    self.order(name: :asc)
  end

  def present_at(lecture)
    attendances.where(lecture: lecture, condition: :present).size > 0
  end
end
