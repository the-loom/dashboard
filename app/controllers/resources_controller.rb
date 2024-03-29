class ResourcesController < ApplicationController
  before_action do
    check_feature(:resources)
  end

  def index
    authorize Resource, :use?
    @resources = Resource.all.includes(:resource_category)
  end

  def new
    authorize Resource, :manage?
    @resource = Resource.new
    @labels = OpenStruct.new(title: "Nuevo recurso", button: "Guardar recurso")
    render :form
  end

  def create
    authorize Resource, :manage?
    @resource = Resource.new(resource_params)
    if @resource.valid?
      @resource.save
      redirect_to resources_path
      flash[:success] = "Se creó correctamente el recurso"
    else
      @labels = OpenStruct.new(title: "Nuevo recurso", button: "Guardar recurso")
      render :form
    end
  end

  def edit
    authorize Resource, :manage?
    @resource = Resource.find(params[:id])
    @labels = OpenStruct.new(title: "Editar recurso", button: "Actualizar recurso")
    render :form
  end

  def update
    authorize Resource, :manage?
    @resource = Resource.find(params[:id])

    if @resource.update(resource_params)
      redirect_to resources_path
      flash[:success] = "Se editó correctamente el recurso"
    else
      render action: :edit
    end
  end

  def destroy
    authorize Resource, :manage?
    resource = Resource.find(params[:id])
    resource.destroy

    redirect_to resources_path
    flash[:success] = "Se eliminó correctamente el recurso"
  end

  def upvote
    authorize Resource, :use?
    resource = Resource.find(params[:id])
    resource.vote_up current_user
    redirect_to resources_path
    flash[:success] = "¡Gracias por tu voto!"
  end

  def downvote
    authorize Resource, :use?
    resource = Resource.find(params[:id])
    resource.vote_down current_user
    redirect_to resources_path
    flash[:success] = "¡Gracias por tu voto!"
  end

  def unvote
    authorize Resource, :use?
    resource = Resource.find(params[:id])
    resource.unvote_up current_user
    resource.unvote_down current_user
    redirect_to resources_path
  end

  private
    def resource_params
      params[:resource].permit(:title, :description, :url, :resource_category_id)
    end
end
