require "rails_helper"

RSpec.describe AutomaticCorrection::Repo, type: :model do
  def enable_log
    ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
  end

=begin
  validates_presence_of :user, :name, :git_url, :description, :difficulty
  validates_numericality_of :difficulty
=end

  it {
    should validate_presence_of(:user)
    should validate_presence_of(:name)
    should validate_presence_of(:description)
    should validate_presence_of(:git_url)
    should validate_presence_of(:difficulty)

    should validate_numericality_of(:difficulty)
  }

  it {
    module CourseLock
      def verify_current_course; end
    end
    should validate_uniqueness_of(:git_url)
               .scoped_to(:course_id)
  }

  it ".full_name" do
    repo = AutomaticCorrection::Repo.new(user: "loom", name: "loom", git_url: "url", description: "Description", difficulty: 5, course: Course.current)

    expect(repo.full_name).to eq("loom/loom")
  end

  it ".latest_test_run" do
    repo = AutomaticCorrection::Repo.create(user: "loom", name: "loom", git_url: "url", description: "Description", difficulty: 5, course: Course.current)
    now = Time.new
    first_test_run = AutomaticCorrection::TestRun.create(created_at: now, score: 5, course: Course.current)
    second_test_run = AutomaticCorrection::TestRun.create(created_at: now + 1, score: 10, course: Course.current)

    repo.test_runs << first_test_run
    repo.test_runs << second_test_run

    expect(repo.latest_test_run).to eq(second_test_run)
  end

  it ".url" do
    repo = AutomaticCorrection::Repo.create(user: "loom", name: "repo")

    expect(repo.url).to eq("https://www.github.com/loom/repo")
  end
end
