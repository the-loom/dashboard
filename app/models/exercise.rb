class Exercise < ApplicationRecord
  #has_many :attendances
  #has_many :users, through: :attendances

  default_scope { order(name: :asc) }
end
