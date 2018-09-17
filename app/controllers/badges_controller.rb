class BadgesController < ApplicationController
  def index
    authorize Badge
    @badges = Badge.all
  end

  def show
    authorize Badge
    @badge = Badge.find(params[:id])
    @students = @badge.users
  end

  def new
    authorize Badge, :create?
    @badge = Badge.new
    @labels = OpenStruct.new(title: 'Nuevo emblema', button: 'Guardar emblema')
    render :form
  end

  def create
    authorize Badge, :create?
    @badge = Badge.new(badge_params)

    if @badge.valid?
      @badge.save
      redirect_to badges_path
      flash[:info] = "Se creo correctamente el emblema"
    else
      render action: :new
    end
  end

  def edit
    authorize Badge, :manage?
    @badge = Badge.find(params[:id])
    @labels = OpenStruct.new(title: 'Editar emblema', button: 'Actualizar emblema')
    render :form
  end

  def update
    authorize Badge, :manage?
    @badge = Badge.find(params[:id])

    if @badge.update_attributes(badge_params)
      redirect_to badges_path
      flash[:info] = "Se actualizó correctamente el emblema"
    else
      render action: :edit
    end
  end

  private
    def badge_params
      params[:badge].permit(:name, :description, :slug, :featured)
    end
end
