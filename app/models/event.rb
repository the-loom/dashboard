class Event < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :description, :points, :min_points, :max_points
  validates :name, uniqueness: { scope: :course_id }

  scope :enabled, -> { where(enabled: true) }

  has_many :occurrences
  has_many :users, through: :occurrences

  belongs_to :competence_tag, optional: true

  def self.min_points
    Event.enabled.sum(:min_points)
  end

  def self.max_points
    Event.enabled.sum(:max_points)
  end
end
