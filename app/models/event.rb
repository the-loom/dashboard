class Event < ApplicationRecord
  include CourseLock

  validates :points, :min_points, :max_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_presence_of :name, :description
  validates :name, uniqueness: { scope: :course_id }
  validate :points_min_and_max

  scope :enabled, -> { where(enabled: true) }

  has_many :occurrences
  has_many :users, through: :occurrences

  belongs_to :competence_tag, optional: true

  def points_min_and_max
    if self.min_points.present? && self.max_points.present? && self.min_points > self.max_points
      errors.add(:min_points, "cannot be greater than max points")
    end
  end

  def min_points
    if self == Course.current.attendance_event
      x = Lecture.past_and_current.size
      (x * 0.75).to_i * points
    else
      super
    end
  end

  def max_points
    if self == Course.current.attendance_event
      x = Lecture.past_and_current.required.size
      x * points
    else
      super
    end
  end

  def self.min_points
    Event.enabled.sum(&:min_points)
  end

  def self.max_points
    Event.enabled.sum(&:max_points)
  end
end
