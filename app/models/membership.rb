class Membership < ApplicationRecord

  include CourseLock
  
  belongs_to :course
  belongs_to :user

  enum role: {
    guest: 0,
    student: 1,
    teacher: 2
  }

end
