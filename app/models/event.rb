class Event < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :description, :points, :min_points, :max_points
  validates :name, uniqueness: { scope: :course_id }
  validate :points_min_and_max

  scope :enabled, -> { where(enabled: true) }

  has_many :occurrences
  has_many :users, through: :occurrences

  belongs_to :competence_tag, optional: true

  def points_min_and_max
    if self.points.present? && self.points < 0
      errors.add(:points, "cannot be less than 0")
    end
    if self.min_points.present? && self.min_points < 0
      errors.add(:min_points, "cannot be less than 0")
    end
    if self.max_points.present? && self.max_points < 0
      errors.add(:max_points, "cannot be less than 0")
    end
    if self.min_points.present? && self.max_points.present? && self.min_points > self.max_points
      errors.add(:min_points, "cannot be greater than max points")
    end  
  end  

  def self.min_points
    Event.enabled.sum(:min_points)
  end

  def self.max_points
    Event.enabled.sum(:max_points)
  end
end
