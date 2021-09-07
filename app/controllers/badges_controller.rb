class BadgesController < ApplicationController
  layout "application5"

  before_action do
    check_feature(:badges)
  end

  def index
    authorize Badge
    @badges = Badge.all
  end

  def show
    authorize Badge
    @badge = Badge.find(params[:id])
    @students = @badge.users
    @earnings = @badge.earnings
  end

  def new
    authorize Badge, :create?
    @badge = Badge.new
    @labels = OpenStruct.new(title: "Nuevo emblema", button: "Guardar emblema")
    render :form
  end

  def create
    authorize Badge, :create?
    @badge = Badge.new(badge_params)

    if @badge.valid?
      @badge.save
      redirect_to badges_path
      flash[:success] = "Se creo correctamente el emblema"
    else
      @labels = OpenStruct.new(title: "Nuevo emblema", button: "Guardar emblema")
      render :form
    end
  end

  def edit
    authorize Badge, :manage?
    @badge = Badge.find(params[:id])
    @labels = OpenStruct.new(title: "Editar emblema", button: "Actualizar emblema")
    render :form
  end

  def update
    authorize Badge, :manage?
    @badge = Badge.find(params[:id])

    if @badge.update_attributes(badge_params)
      redirect_to badges_path
      flash[:success] = "Se actualizó correctamente el emblema"
    else
      @labels = OpenStruct.new(title: "Editar emblema", button: "Actualizar emblema")
      render :form
    end
  end

  def unregister
    authorize Badge, :register?
    Earning.where(user_id: params[:user_id], badge_id: params[:id]).delete_all
    redirect_to badge_path(Badge.find(params[:id]))
  end

  private
    def badge_params
      params[:badge].permit(:name, :description, :image, :featured)
    end
end
