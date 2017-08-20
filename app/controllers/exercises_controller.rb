class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all
  end
  def new
    @exercise = Exercise.new
  end
  def create
    authorize Exercise, :create?
    @exercise = Exercise.new(exercise_params)
    if @exercise.save
      flash[:notice] = "Se creo correctamente el ejercicio"
    end
    redirect_to exercises_path
  end

  def show
    authorize Lecture
    @exercise = Exercise.find(params[:id])
  end

  private
  def exercise_params
    params[:exercise].permit(:name, :url, :notes)
  end

end
