class Badge < ApplicationRecord
  
  include CourseLock
  
  has_many :earnings
  has_many :users, through: :earnings
end
