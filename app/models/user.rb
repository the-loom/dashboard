class User < ApplicationRecord
  enum role: {
      guest: 0,
      student: 1,
      teacher: 2
  }

  has_many :identities

  has_many :user_tags
  has_many :tags, through: :user_tags

  has_many :occurrences, -> { order(created_at: :desc) }
  has_many :events, through: :occurrences

  has_many :earnings, -> { order(created_at: :desc) }
  has_many :badges, through: :earnings

  has_many :attendances
  has_many :lectures, through: :attendances

  has_many :comments

  has_many :user_solutions
  has_many :solutions, through: :user_solutions

  belongs_to :team, optional: true

  def update_with(identity)
    self.nickname = identity.nickname
    self.name = identity.name
    self.email = identity.email
    self.image = identity.image
    self.save
    self
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).users
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end

# TODO(delucas): remove. Dead feature?
=begin
  def image
    current_user = User.find(session[:user_id])
    if current_user.teacher?
      secondary_image || read_attribute(:image)
    else
      read_attribute(:image)
    end
  end
=end

  def level
    Level.new(points, badges.size).value
  end

  def unregister_attendance(lecture)
    if attendances.detect { |a| a.present? && a.lecture == lecture }
      self.points = self.points - 10
      self.save!
    end
    Attendance.find_by(user: self, lecture: lecture).try(:delete)
  end

  def register_attendance(lecture, condition)
    if condition == :present
      self.points = self.points + 10
      self.save!
    end
    attendances.create(lecture: lecture, condition: condition)
  end

  def register(event)
    events_count = events.count { |x| x.name == event.name } + 1
    if events_count % event.batch_size == 0
      points_per_event = event.points_per_batch
    else
      points_per_event = 0
    end
    occurrences.create(event: event, points: points_per_event)
    self.points = self.points + points_per_event
    self.save!
  end

  def earn(badge)
    earnings.create(badge: badge)
  end

  def self.sorted
    self.order(points: :desc)
  end

  def self.sorted_by_name
    self.order(name: :asc)
  end

  def present_at(lecture)
    attendances.where(lecture: lecture, condition: :present).size > 0
  end
end
