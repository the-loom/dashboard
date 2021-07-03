class Notification < ApplicationRecord
  include CourseLock
  belongs_to :receiver, optional: true, class_name: "User"

  validates_presence_of :subject, :text, :author

  default_scope { order(created_at: :desc) }

  # TODO Improve: add unread_notifications in after create. Check recipients
end
