class Team < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :nickname, :image
  validates :name, uniqueness: { scope: :course_id }
  validates :nickname, uniqueness: { scope: :course_id }

  has_many :memberships
  has_many :members, through: :memberships, source: :user, class_name: "User"

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
    ScoreCalculator.new.score_for(points)
  end
end
