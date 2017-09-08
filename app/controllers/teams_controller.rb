class TeamsController < ApplicationController

  def index
    authorize Team
    @teams = Team.sorted
  end

  def show
    @team = Team.where(nickname: params[:nickname]).first if params[:nickname]
    @presenter = ReadingsGraphPresenter.new(@team.measurements)
    authorize @team
  end

  def new
    authorize Team, :create?
    @team = Team.new
  end

  def create
    authorize Team, :create?
    @team = Team.new(team_params)
    if @team.save
      flash[:notice] = "Se creo correctamente el equipo"
    end
    redirect_to teams_path
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
