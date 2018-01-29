class ReposController < ApplicationController
  def index
    @repos = AutomaticCorrection::Repo.where(parent: nil)
  end

  def show
    @repo = AutomaticCorrection::Repo.find_by(user: params[:user], name: params[:name])
    @forks = current_user.teacher? ? @repo.forks : @repo.forks.where(author: current_user)
  end

  def grade
    repo = AutomaticCorrection::Repo.find_by(user: params[:user], name: params[:name])
    if repo.parent == nil
      fork = AutomaticCorrection::Repo.find_or_create_by(parent: repo, author: current_user, user: current_user.github_username, name: repo.name)
      fork.update_attributes(pending: true, git_url: "git@github.com:#{current_user.github_username}/#{repo.name}.git")
    end

    redirect_to repo_path(user: repo.user, name: repo.name)
  end

  def next_pending_fork
    if request.headers["x-api-key"] != ENV["GRADER_TOKEN"]
      render nothing: true, status: :forbidden
      return
    end

    fork = AutomaticCorrection::Repo.find_by(user: params[:user], name: params[:name])
        .forks.where(pending: true).order(updated_at: :asc).first
    render json: fork.to_json(only: [:id, :user, :name, :git_url ],
                              include: {
                                  parent: { only: [:user, :name, :git_url ] }
                              })
  end

  def update
    if request.headers["x-api-key"] != ENV["GRADER_TOKEN"]
      render nothing: true, status: :forbidden
      return
    end

    5/0

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
      params.require(who).permit(:user, :name)
    end

    def issue_params(issue)
      issue.permit!
    end
end
