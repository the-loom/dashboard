class Earning < ApplicationRecord
  include CourseLock

  belongs_to :user
  belongs_to :badge

  default_scope { order(created_at: :asc) }
end
