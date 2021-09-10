class Post < ApplicationRecord
  include CourseLock

  validates_presence_of :text, :author

  default_scope { order(pinned: :desc, created_at: :desc) }

  belongs_to :author, class_name: "User"
  belongs_to :notification, optional: true

  after_destroy { self.notification&.destroy }

  def notify!
    self.notification = Notification.create(subject: "¡Hay un nuevo anuncio de '#{author.full_name}'!", author: "Loombot",
                        text: "#{text}<br><a href='/dashboard?post=#{id}'>Ir al anuncio</a>")
    save!

    Course.current.memberships.each do |membership|
      membership.unread_notifications += 1
      membership.save!
    end
  end
end
