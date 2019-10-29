class TeamsController < ApplicationController
  before_action do
    check_feature(:teams)
  end

  def index
    authorize Team
    @teams = Team.sorted
  end

  def show
    @team = Course.current.teams.find_by(nickname: params[:nickname]) if params[:nickname]
    authorize @team, :manage?
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
    @team = Course.current.teams.find(params[:id])
    authorize @team, :manage?
    @labels = OpenStruct.new(title: "Editar equipo", button: "Actualizar equipo")
    render :form
  end

  def update
    @team = Course.current.teams.find(params[:id])
    authorize @team, :manage?

    if @team.update_attributes(team_params)
      redirect_to team_profile_path(@team.nickname)
      flash[:info] = "Se actualizó correctamente el equipo"
    else
      if current_user.teacher?
        @labels = OpenStruct.new(title: "Editar equipo", button: "Actualizar equipo")
        render action: :form
      else
        render action: :show
      end
    end
  end

  def destroy
    @team = Course.current.teams.find(params[:id])
    if @team.enabled_members.size == 0
      @team.destroy
      flash[:info] = "Se eliminó el equipo '#{@team.name}'"
    end
    redirect_to teams_path
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
      params[:team].permit(:name, :nickname, :avatar)
    end
end
