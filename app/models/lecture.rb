class Lecture < ApplicationRecord
  include CourseLock

  validates_presence_of :date, :summary
  validates :summary, uniqueness: { scope: :course_id }

  has_many :attendances
  has_many :users, through: :attendances

  default_scope { order(date: :asc) }
  scope :required, -> { where(required: true) }

end
