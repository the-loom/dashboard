class Event < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :description, :points, :min_points, :max_points
  validates :name, uniqueness: { scope: :course_id }

  has_many :occurrences
  has_many :users, through: :occurrences

  def self.min_points
    Event.all.sum(:min_points)
  end

  def self.max_points
    Event.all.sum(:max_points)
  end
end
