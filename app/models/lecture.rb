class Lecture < ApplicationRecord
  include CourseLock

  validates_presence_of :date, :summary
  validates :summary, uniqueness: { scope: :course_id }

  default_scope { order(date: :asc) }
  scope :required, -> { where(required: true) }

  def self.current
    where("date between ? and ?", Time.new.beginning_of_day, Time.new.end_of_day).first
  end

  def current?
    date.to_date == Time.new.to_date
  end
end
