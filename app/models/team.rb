class Team < ApplicationRecord
  has_many :members, :class_name => "User"

  has_many :measurements
  has_many :readings, through: :measurements, source: :reading

  def self.sorted
    self.order(:name)
  end
end
