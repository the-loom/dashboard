class TeamsController < ApplicationController
  def index
    authorize Team
    @teams = Team.sorted
  end

  def show
    @team = Team.where(nickname: params[:nickname]).first if params[:nickname]
    authorize @team
  end

  def new
    authorize Team, :create?
    @team = Team.new
  end

  def create
    authorize Team, :create?
    @team = Team.new(team_params)

    if @team.valid?
      @team.save
      redirect_to team_profile_path(@team.nickname)
      flash[:notice] = "Se creo correctamente el equipo"
    else
      render action: :new
    end
  end

  def add_member
    @team = Team.find(params[:team_id])
    authorize @team
    member = User.where(nickname: params[:nickname])
    @team.members << member

    redirect_to team_profile_url(@team.nickname)
  end

  private
    def team_params
      params[:team].permit(:name, :nickname, :image)
    end
end
