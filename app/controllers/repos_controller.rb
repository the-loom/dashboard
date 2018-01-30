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
end
