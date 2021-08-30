class Lecture < ApplicationRecord
  include CourseLock

  validates_presence_of :date, :time_from, :time_to, :summary
  validates :summary, uniqueness: { scope: :course_id }

  default_scope { order(date: :asc) }
  scope :required, -> { where(required: true) }
  scope :past_and_current, -> { where("date < ?", Time.zone.now.end_of_day) }

  def self.current
    now = Time.zone.now
    where("date between ? and ? and time_from < ? and time_to > ?", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day, now, now).first
  end

  def current?
    now = Time.zone.now
    if time_from.present? && time_to.present?
      date_from = date + time_from.hour.hours + time_from.min.minutes - 30.minutes
      date_to = date + time_to.hour.hours + time_to.min.minutes + 30.minutes
      date.to_date == now.to_date && date_from.utc <= now && now <= date_to.utc
    else
      date.to_date == now.to_date
    end
  end
end
