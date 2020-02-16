class Exercise < ApplicationRecord
  include CourseLock
  include Publishable

  validates_presence_of :name
  validates :name, uniqueness: { scope: :course_id }

  default_scope { order(name: :asc) }
  scope :published, -> { where(published: true) }
end
