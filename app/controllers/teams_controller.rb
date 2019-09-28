class TeamsController < ApplicationController
  before_action do
    check_feature(:teams)
  end

  def index
    authorize Team
    @teams = Team.sorted
  end

  def show
    @team = Course.current.teams.where(nickname: params[:nickname]).first if params[:nickname]
    authorize @team
  end

  def new
    authorize Team, :create?
    @team = Team.new
    @labels = OpenStruct.new(title: "Nuevo equipo", button: "Guardar equipo")
    render :form
  end

  def create
    authorize Team, :create?
    @team = Team.new(team_params)

    if @team.valid?
      @team.save
      redirect_to team_profile_path(@team.nickname)
      flash[:info] = "Se creo correctamente el equipo"
    else
      render action: :new
    end
  end

  def edit
    authorize Team, :manage?
    @team = Course.current.teams.find(params[:id])
    @labels = OpenStruct.new(title: "Editar equipo", button: "Actualizar equipo")
    render :form
  end

  def update
    authorize Team, :manage?
    @team = Course.current.teams.find(params[:id])

    if @team.update_attributes(team_params)
      redirect_to team_profile_path(@team.nickname)
      flash[:info] = "Se actualizó correctamente el equipo"
    else
      render action: :edit
    end
  end

  def add_member
    @team = Course.current.teams.find(params[:team_id])
    authorize @team
    membership = Membership.where(user: User.where(nickname: params[:nickname]),
                                  course: current_user.current_membership.course)
    @team.memberships << membership

    redirect_to team_profile_url(@team.nickname)
  end

  private
    def team_params
      params[:team].permit(:name, :nickname, :image)
    end
end
