class Reading < ApplicationRecord
  has_many :measurements, class_name: 'Measurement'
  has_many :teams, through: :measurements
end
