class Team < ApplicationRecord
  include CourseLock

  validates_presence_of :name, :nickname, :image
  validates :name, uniqueness: { scope: :course }
  validates :nickname, uniqueness: { scope: :course }

  has_many :members, class_name: "User"
  belongs_to :course

  def self.sorted
    self.order(:name)
  end

  def badges
    members.select { |m| m.enabled }.collect { |member| member.badges }.flatten
  end

  def points
    return 0 if members.empty?
    enabled_members = members.select { |m| m.enabled }
    enabled_members.sum(&:points) / enabled_members.size
  end
end
