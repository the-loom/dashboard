class CompetenceTagsController < ApplicationController
  before_action do
    check_feature(:competences)
  end

  def index
    authorize CompetenceTag
    @competence_tags = CompetenceTag.all
  end

  def new
    authorize CompetenceTag, :create?
    @competence_tag = CompetenceTag.new
    @labels = OpenStruct.new(title: "Nueva competencia", button: "Guardar competencia")
    render :form
  end

  def create
    authorize CompetenceTag, :create?
    @competence_tag = CompetenceTag.new(competence_tag_params)

    if @competence_tag.valid?
      @competence_tag.save
      redirect_to competence_tags_path
      flash[:success] = "Se creo correctamente la competencia"
    else
      @labels = OpenStruct.new(title: "Nueva competencia", button: "Guardar competencia")
      render :form
    end
  end

  def edit
    authorize CompetenceTag, :manage?
    @competence_tag = CompetenceTag.find(params[:id])
    @labels = OpenStruct.new(title: "Editar competencia", button: "Actualizar competencia")
    render :form
  end

  def update
    authorize CompetenceTag, :manage?
    @competence_tag = CompetenceTag.find(params[:id])

    if @competence_tag.update_attributes(competence_tag_params)
      redirect_to competence_tags_path
      flash[:success] = "Se actualizó correctamente la competencia"
    else
      @labels = OpenStruct.new(title: "Editar competencia", button: "Actualizar competencia")
      render :form
    end
  end

  private
    def competence_tag_params
      params[:competence_tag].permit(:name)
    end
end
