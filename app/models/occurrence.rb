class Occurrence < ApplicationRecord
  belongs_to :user
  belongs_to :event

  default_scope { order(created_at: :asc) }
end
