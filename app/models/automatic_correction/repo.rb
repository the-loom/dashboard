class AutomaticCorrection::Repo < ApplicationRecord
  include CourseLock
  include Publishable
  include HasDifficulty

  has_many :forks, foreign_key: "parent_id", class_name: "AutomaticCorrection::Repo"

  belongs_to :parent, class_name: "AutomaticCorrection::Repo", optional: true
  belongs_to :author, class_name: "User", optional: true

  has_many :test_runs, foreign_key: :automatic_correction_repo_id, class_name: "AutomaticCorrection::TestRun"

  validates_presence_of :user, :name, :git_url, :description
  validates :git_url, uniqueness: { scope: :course_id }

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
