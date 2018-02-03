class Team < ApplicationRecord
  
  include CourseLock
  
  has_many :members, class_name: "User"

  has_many :measurements
  has_many :readings, through: :measurements, source: :reading

  has_many :checks, -> { order(created_at: :desc) }
  has_many :checkpoints, through: :checks

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
