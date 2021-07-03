class ExercisesController < ApplicationController
  include Publisher.new(Exercise)

  layout "application2"

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
      flash[:success] = "Se creó correctamente el ejercicio"
    else
      @labels = OpenStruct.new(title: "Nuevo ejercicio", button: "Guardar ejercicio")
      render :form
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
      flash[:success] = "Se editó correctamente el ejercicio"
    else
      @labels = OpenStruct.new(title: "Editar ejercicio", button: "Actualizar ejercicio")
      render :form
    end
  end

  def show
    @exercise = Exercise.find_by(id: params[:id])

    unless @exercise
      # we try to find the exercise in other courses
      @exercise = Exercise.unscoped.find_by(id: params[:id])
      if @exercise
        course = @exercise.course
        unless current_user.current_membership(course).nil?
          course.switch(current_user, session)
          menu # rebuilds the menu
        end
      end
    end

    unless @exercise
      flash[:alert] = "No pudimos encontrar el ejercicio que buscás..."
      redirect_to(dashboard_index_path) && return
    end

    authorize @exercise, :show?
  end

  private
    def exercise_params
      params[:exercise].permit(:name, :notes, :difficulty)
    end
end
