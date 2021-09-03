class Exercise < ApplicationRecord
  include CourseLock
  include Publishable
  include HasDifficulty

  acts_as_taggable_on :tags

  validates_presence_of :name, :notes
  validates :name, uniqueness: { scope: :course_id }

  default_scope { order(name: :asc) }

  def to_param
    [id, name.parameterize].join("-")
  end

  def current?
    return false unless start_date
    self.start_date.beginning_of_day < Time.zone.now
  end
end
