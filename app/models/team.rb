class Team < ApplicationRecord
  include CourseLock

  has_one_attached :avatar

  serialize :stats, JSON

  validates_presence_of :name, :nickname
  validates :name, uniqueness: { scope: :course_id }

  # TODO: use slug, remove nickname
  validates :nickname, uniqueness: { scope: :course_id }
  validates :avatar, size: { less_than: 500.kilobyte }, content_type: [:png, :jpg, :jpeg]

  has_many :memberships
  has_many :members, through: :memberships, source: :user, class_name: "User"

  acts_as_taggable_on :tags

  def self.sorted
    self.order(:name)
  end

  def badges
    members.select { |m| m.enabled? }.collect { |member| member.badges }.flatten
  end

  def enabled_members
    members.includes(:memberships).select { |m| m.enabled? }
  end

  def refresh_points_cache!
    if enabled_members.empty?
      self.points = 0
    else
      self.points = enabled_members.sum(&:points) / enabled_members.size
    end
    save
  end

  def score
    ScoreCalculator.new.score_for(points)
  end

  def self.generate_nickname
    Time.new.to_i.to_s26
  end
end
