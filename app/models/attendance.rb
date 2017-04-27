class Attendance < ApplicationRecord

  enum condition: {
      absent: 0,
      present: 1
  }

  belongs_to :user
  belongs_to :lecture
end
