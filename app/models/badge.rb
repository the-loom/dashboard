class Badge < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :description, :slug
  validates :name, uniqueness: { scope: :course_id }
  validates :slug, uniqueness: { scope: :course_id }

  has_many :earnings
  has_many :users, through: :earnings
end
