class Event < ApplicationRecord
  
  include CourseLock
  
  has_many :occurrences
  has_many :users, through: :occurrences
end
