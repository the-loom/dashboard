class Checkpoint < ApplicationRecord
  
  include CourseLock
  
  has_many :checks
  has_many :teams, through: :checks
end
