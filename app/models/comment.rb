class Comment < ApplicationRecord
  
  include CourseLock
  
  enum mood: {
      bad: -1,
      neutral: 0,
      good: 1
  }

  belongs_to :commenter, class_name: "User"

  default_scope { order(created_at: :desc) }
end
