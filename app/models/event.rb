class Event < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :description, :batch_size, :points_per_batch
  validates :name, uniqueness: { scope: :course_id }

  has_many :occurrences
  has_many :users, through: :occurrences
end
