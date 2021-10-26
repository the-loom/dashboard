class Comment < ApplicationRecord
  include CourseLock

  belongs_to :commenter, class_name: "User"

  default_scope { order(created_at: :desc) }
end
