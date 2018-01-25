class ReposController < ApplicationController
  def index
    @repos = AutomaticCorrection::Repo.where(parent: nil)
  end

  def show
    @repo = AutomaticCorrection::Repo.find_by(user: params[:user], name: params[:name])
  end

  def update
    if request.headers["x-api-key"] != ENV["GRADER_TOKEN"]
      render nothing: true, status: :forbidden
      return
    end

    parent = AutomaticCorrection::Repo.where(user: params[:parent][:user], name: params[:parent][:name]).first

    unless parent
      parent = AutomaticCorrection::Repo.create(repo_params(:parent))
    end

    fork = parent.forks.where(user: params[:fork][:user]).first

    if fork
      fork.update_attributes(repo_params(:fork))
    else
      fork = AutomaticCorrection::Repo.create(repo_params(:fork))
      parent.forks << fork
    end

    test_run = AutomaticCorrection::TestRun.create(
      score: params[:test_run][:score][:value],
      details: params[:test_run][:details]
    )

    if params[:test_run][:results]
      params[:test_run][:results].each do |result|

        res = AutomaticCorrection::Result.create(
          test_type: result[:type],
          score: result[:score][:value]
        )

        result[:issues].each do |issue|
          iss = AutomaticCorrection::Issue.create(issue_params(issue))
          res.issues << iss
        end

        test_run.results << res
      end
    end

    fork.test_runs << test_run

    # TODO: handle errors here
    render nothing: true, status: :ok
  end

  private

    def repo_params(who)
      params.require(who).permit(:user, :name, :git_url, :avatar_url, :description)
    end

    def issue_params(issue)
      issue.permit!
    end
end
