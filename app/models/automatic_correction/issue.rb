class AutomaticCorrection::Issue < ApplicationRecord
  belongs_to :result, foreign_key: :automatic_correction_result_id
  serialize :payload, JSON
end
