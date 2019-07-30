class Team < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :nickname, :image
  validates :name, uniqueness: { scope: :course_id }
  validates :nickname, uniqueness: { scope: :course_id }

  has_many :memberships
  has_many :members, through: :memberships, source: :user, class_name: "User"
  belongs_to :course

  def self.sorted
    self.order(:name)
  end

  def badges
    members.select { |m| m.enabled? }.collect { |member| member.badges }.flatten
  end

  def enabled_members
    members.select { |m| m.enabled? }
  end

  def points
    return 0 if enabled_members.empty?
    enabled_members.sum(&:points) / enabled_members.size
  end

  def score
    min = Event.min_points
    max = Event.max_points
    spread = max - min
    pts = self.points
    normalized = pts - min
    if pts < min
      2.0
    elsif pts > max
      10.0
    else
      (normalized.to_f / spread) * 6 + 4
    end
  end
end
