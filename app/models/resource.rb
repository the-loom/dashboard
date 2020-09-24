class Resource < ApplicationRecord
  include CourseLock
  acts_as_votable

  validates_presence_of :title, :description, :url
  validates :title, uniqueness: { scope: :course_id }
  validates :url, uniqueness: { scope: :course_id }

  belongs_to :resource_category

  default_scope { order(title: :asc) }
end
