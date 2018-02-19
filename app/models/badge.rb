class Badge < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :description, :slug
  validates :name, uniqueness: { scope: :course_id }
  validates_uniqueness_of :slug

  has_many :earnings
  has_many :users, through: :earnings
end
