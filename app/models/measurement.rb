class Measurement < ApplicationRecord
  belongs_to :team
  belongs_to :reading

  default_scope { order(created_at: :asc) }
end
