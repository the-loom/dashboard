class Event < ApplicationRecord
  has_many :occurrences
  has_many :users, through: :occurrences
end
