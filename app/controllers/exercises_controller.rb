class ExercisesController < ApplicationController

  include Publisher.new(Exercise)

  before_action do
    check_feature(:exercises)
  end

  def index
    if current_user.teacher?
      @exercises = Exercise.all
    else
      @exercises = Exercise.published
    end
  end

  def new
    authorize Exercise, :new?
    @exercise = Exercise.new
    @labels = OpenStruct.new(title: "Nuevo ejercicio", button: "Guardar ejercicio")
    render :form
  end

  def create
    authorize Exercise, :create?
    @exercise = Exercise.new(exercise_params)
    if @exercise.valid?
      @exercise.save
      redirect_to exercises_path
      flash[:info] = "Se creó correctamente el ejercicio"
    else
      render action: :new
    end
  end

  def edit
    authorize Exercise, :create?
    @exercise = Exercise.find(params[:id])
    @labels = OpenStruct.new(title: "Editar ejercicio", button: "Actualizar ejercicio")
    render :form
  end

  def update
    authorize Exercise, :create?
    @exercise = Exercise.find(params[:id])

    if @exercise.update_attributes(exercise_params)
      redirect_to exercises_path
      flash[:info] = "Se editó correctamente el ejercicio"
    else
      render action: :edit
    end
  end

  def show
    @exercise = Exercise.find(params[:id])
    authorize @exercise
  end

  private
    def exercise_params
      params[:exercise].permit(:name, :notes)
    end
end
