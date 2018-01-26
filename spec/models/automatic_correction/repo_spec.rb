require 'rails_helper'

RSpec.describe AutomaticCorrection::Repo, type: :model do

  def enable_log
    ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
  end

  it ".full_name" do

    repo = AutomaticCorrection::Repo.create({user: 'loom', name: 'loom'})

    expect(repo.full_name).to eq("loom/loom")
  end

  it ".forks / .parent" do

    parent = AutomaticCorrection::Repo.create({user: 'loom', name: 'loom'})
    fork = AutomaticCorrection::Repo.create({user: 'loom', name: 'loom'})

    parent.forks << fork

    expect(parent.forks).to contain_exactly(fork)
    expect(fork.parent).to eq(parent)
  end

  it ".latest_test_run" do

    repo = AutomaticCorrection::Repo.create({user: 'loom', name: 'loom'})
    now = Time.new
    first_test_run = AutomaticCorrection::TestRun.create({created_at: now, score: 5})
    second_test_run = AutomaticCorrection::TestRun.create({created_at: now + 1, score: 10})
    repo.test_runs << first_test_run
    repo.test_runs << second_test_run

    expect(repo.latest_test_run).to eq(second_test_run)

  end

  it ".url" do

    repo = AutomaticCorrection::Repo.create({user: 'loom', name: 'repo'})
    expect(repo.url).to eq('https://www.github.com/loom/repo')

  end

end
