class Team < ApplicationRecord
  has_many :members, :class_name => "User"

  has_many :measurements
  has_many :readings, through: :measurements, source: :reading

  has_many :checks
  has_many :checkpoints, -> { order(created_at: :desc) }, through: :checks

  def self.sorted
    self.order(:name)
  end

  def badges
    members.select { |m| m.enabled }.collect { |member| member.badges }.flatten
  end

  def points
    enabled_members = members.select { |m| m.enabled }
    enabled_members.sum(&:points) / enabled_members.size
  end
end
