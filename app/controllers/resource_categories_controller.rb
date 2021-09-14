class ResourceCategoriesController < ApplicationController
  before_action do
    check_feature(:resources)
  end

  def index
    authorize Resource, :manage?
    @resource_categories = ResourceCategory.all
  end

  def new
    authorize Resource, :manage?
    @resource_category = ResourceCategory.new
    @labels = OpenStruct.new(title: "Nueva categoría de recursos", button: "Guardar categoría")
    render :form
  end

  def create
    authorize Resource, :manage?
    @resource_category = ResourceCategory.new(resource_params)
    if @resource_category.valid?
      @resource_category.save
      redirect_to resource_categories_path
      flash[:success] = "Se creó correctamente la categoría"
    else
      @labels = OpenStruct.new(title: "Nueva categoría de recursos", button: "Guardar categoría")
      render :form
    end
  end

  def edit
    authorize Resource, :manage?
    @resource_category = ResourceCategory.find(params[:id])
    @labels = OpenStruct.new(title: "Editar categoría de recursos", button: "Actualizar categoría")
    render :form
  end

  def update
    authorize Resource, :manage?
    @resource_category = ResourceCategory.find(params[:id])

    if @resource_category.update_attributes(resource_params)
      redirect_to resource_categories_path
      flash[:success] = "Se editó correctamente la categoría"
    else
      @labels = OpenStruct.new(title: "Editar categoría de recursos", button: "Actualizar categoría")
      render :form
    end
  end

  def destroy
    authorize Resource, :manage?
    resource_category = ResourceCategory.find(params[:id])
    resource_category.destroy

    redirect_to resource_categories_path
    flash[:success] = "Se eliminó correctamente la categoría"
  end

  private
    def resource_params
      params[:resource_category].permit(:name)
    end
end
