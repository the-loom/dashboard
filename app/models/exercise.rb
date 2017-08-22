class Exercise < ApplicationRecord
  has_many :solutions

  default_scope { order(name: :asc) }
end
