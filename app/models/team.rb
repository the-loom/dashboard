class Team < ApplicationRecord
  has_many :members, :class_name => "User"

  has_many :measurements
  has_many :readings, through: :measurements, source: :reading

  has_many :checks
  has_many :checkpoints, through: :checks

  def self.sorted
    self.order(:name)
  end

  def badges
    members.collect { |member| member.badges }.flatten
  end

  def points
    members.sum(&:points) / members.size
  end
end
