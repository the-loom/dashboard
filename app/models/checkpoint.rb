class Checkpoint < ApplicationRecord
  has_many :checks
  has_many :teams, through: :checks
end
