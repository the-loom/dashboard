class UserSolution < ApplicationRecord
  
  include CourseLock
  
  belongs_to :user
  belongs_to :solution
end
