class Faq < ApplicationRecord
  include CourseLock
  acts_as_taggable_on :tags

  validates_presence_of :question, :answer
  validates :question, uniqueness: { scope: :course_id }

  default_scope { order(question: :asc) }
end
