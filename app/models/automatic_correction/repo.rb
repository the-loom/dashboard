class AutomaticCorrection::Repo < ApplicationRecord
  has_many :forks, foreign_key: "parent_id", class_name: "AutomaticCorrection::Repo"
  belongs_to :parent, class_name: "AutomaticCorrection::Repo"

  has_many :test_runs, foreign_key: :automatic_correction_repo_id, class_name: "AutomaticCorrection::TestRun"

  def full_name
    "#{user}/#{name}"
  end

  def latest_test_run
    test_runs.order(created_at: :desc).first
  end

  def url
    "https://www.github.com/#{user}/#{name}"
  end
end
