class Event < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :description, :points, :min_points, :max_points
  validates :name, uniqueness: { scope: :course_id }

  has_many :occurrences
  has_many :users, through: :occurrences
end
