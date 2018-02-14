class Team < ApplicationRecord
  include CourseLock

  has_many :members, class_name: "User"

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
