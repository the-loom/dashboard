class Team < ApplicationRecord
  include CourseLock

  has_one_attached :avatar

  validates_presence_of :name, :nickname
  validates :name, uniqueness: { scope: :course_id }
  validates :nickname, uniqueness: { scope: :course_id }
  validates :avatar, size: { less_than: 1.megabyte }, content_type: [:png, :jpg, :jpeg]


  has_many :memberships
  has_many :members, through: :memberships, source: :user, class_name: "User"

  def self.sorted
    self.order(:name)
  end

  def stats
    ::TeamCompetenceTagsStats.new(self)
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
