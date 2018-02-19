class Notification < ApplicationRecord
  include CourseLock

  validates_presence_of :subject, :text, :author

  default_scope { order(created_at: :desc) }
end
