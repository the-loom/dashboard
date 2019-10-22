class CompetenceTag < ApplicationRecord
  include CourseLock

  validates_presence_of :name
  validates :name, uniqueness: { scope: :course_id }

  has_many :events
end
