class AutomaticCorrection::TestRun < ApplicationRecord
  include CourseLock

  belongs_to :repo, foreign_key: :automatic_correction_repo_id

  has_many :results, foreign_key: :automatic_correction_test_run_id, class_name: "AutomaticCorrection::Result"
end
