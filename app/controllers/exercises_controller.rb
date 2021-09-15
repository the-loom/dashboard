class ExercisesController < ApplicationController
  include Publisher.new(Exercise)
  include Extensions::Discarder.new(Exercise)

  layout "application5"

  before_action do
    check_feature(:exercises)
  end

  def index
    authorize Exercise, :manage?
    @exercises = Exercise.kept.published
    @drafts = Exercise.kept.draft
  end

  def new
    authorize Exercise, :manage?
    @exercise = Exercise.new
    @labels = OpenStruct.new(title: "Nuevo ejercicio", button: "Guardar ejercicio")
    render :form
  end

  def create
    authorize Exercise, :manage?
    @exercise = Exercise.new(exercise_params)
    @exercise.published = false

    if @exercise.valid?
      @exercise.save
      redirect_to exercises_path
      flash[:success] = "Se creó correctamente el ejercicio"
    else
      @labels = OpenStruct.new(title: "Nuevo ejercicio", button: "Guardar ejercicio")
      render :form
    end
  end

  def edit
    authorize Exercise, :manage?
    @exercise = Exercise.find(params[:id])
    @labels = OpenStruct.new(title: "Editar ejercicio", button: "Actualizar ejercicio")
    render :form
  end

  def update
    authorize Exercise, :manage?
    @exercise = Exercise.find(params[:id])

    if @exercise.update_attributes(exercise_params)
      redirect_to exercises_path
      flash[:success] = "Se editó correctamente el ejercicio"
    else
      @labels = OpenStruct.new(title: "Editar ejercicio", button: "Actualizar ejercicio")
      render :form
    end
  end

  def show
    @exercise = Exercise.find_by(id: params[:id])

    # we try to find the exercise in other courses
    @exercise ||= load_exercise(Exercise.unscoped.find_by(id: params[:id]))

    unless @exercise
      flash[:alert] = "No pudimos encontrar el ejercicio que buscás..."
      redirect_to(dashboard_index_path) && return
    end

    authorize @exercise, :show?
  end

  private
    def exercise_params
      params[:exercise].permit(:name, :notes, :difficulty, :tag_list, :start_date)
    end
end
