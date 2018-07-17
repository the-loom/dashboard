class ReposController < ApplicationController
  def index
    @repos = AutomaticCorrection::Repo.where(parent: nil)
  end

  def show
    @repo = AutomaticCorrection::Repo.find_by(user: params[:user], name: params[:name])
    @presenter = RepoHistoryPresenter.new(@repo)
    @forks = current_user.teacher? ? @repo.forks : @repo.forks.where(author: current_user)
  end

  def new
    authorize AutomaticCorrection::Repo, :manage?
    @repo = AutomaticCorrection::Repo.new
  end

  def create
    authorize AutomaticCorrection::Repo, :manage?
    @repo = AutomaticCorrection::Repo.new(repo_params)

    if @repo.valid?
      @repo.save
      redirect_to repos_path
      flash[:notice] = "Se creo correctamente el desafío"
    else
      render action: :new
    end
  end

  def grade
    repo = AutomaticCorrection::Repo.find_by(user: params[:user], name: params[:name])


    if repo.parent == nil
      fork = AutomaticCorrection::Repo.find_or_create_by(parent: repo, author: current_user, user: current_user.github_username, name: repo.name, difficulty: repo.difficulty, description: repo.description)
      fork.update_attributes(pending: true, git_url: "git@github.com:#{current_user.github_username}/#{repo.name}.git")
    end

    redirect_to repo_path(user: repo.user, name: repo.name)
  end

  private

    def repo_params
      params[:automatic_correction_repo].permit(:user, :name, :git_url, :avatar_url, :description, :difficulty)
    end
end
