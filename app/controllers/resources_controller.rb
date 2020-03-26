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
    authorize Resource, :create?
    @resource = Resource.new(resource_params)
    if @resource.valid?
      @resource.save
      redirect_to resources_path
      flash[:info] = "Se creó correctamente el recurso"
    else
      render action: :new
    end
  end

  def edit
    authorize Resource, :create?
    @resource = Resource.find(params[:id])
    @labels = OpenStruct.new(title: "Editar recurso", button: "Actualizar recurso")
    render :form
  end

  def update
    authorize Resource, :create?
    @resource = Resource.find(params[:id])

    if @resource.update_attributes(resource_params)
      redirect_to resources_path
      flash[:info] = "Se editó correctamente el recurso"
    else
      render action: :edit
    end
  end

  private
    def resource_params
      params[:resource].permit(:title, :description, :url, :resource_category_id)
    end
end
