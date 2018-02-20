class AutomaticCorrection::Result < ApplicationRecord
  include CourseLock

  belongs_to :test_run, foreign_key: :automatic_correction_test_run_id
  has_many :issues, foreign_key: :automatic_correction_result_id, class_name: "AutomaticCorrection::Issue"
end
