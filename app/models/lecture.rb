class Lecture < ApplicationRecord
  include CourseLock

  has_many :attendances
  has_many :users, through: :attendances

  default_scope { order(date: :asc) }
end
