class ResourceCategory < ApplicationRecord
  include CourseLock

  validates_presence_of :name
  validates :name, uniqueness: { scope: :course_id }

  has_many :resources

  default_scope { order(name: :asc) }
end
