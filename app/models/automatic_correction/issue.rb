class AutomaticCorrection::Issue < ApplicationRecord
  include CourseLock

  belongs_to :result, foreign_key: :automatic_correction_result_id
  serialize :payload, JSON
end
