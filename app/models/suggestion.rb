class Suggestion < ApplicationRecord
  include CourseLock
  include Discard::Model
  acts_as_votable

  validates_presence_of :title, :body

  enum suggestion_type: {
      course: 0,
      platform: 1
  }

  belongs_to :author, class_name: "User"
end
