class ExercisesController < ApplicationController
  before_action :verify_pending_solutions, only: [:show, :index]

  def index
    @exercises = Exercise.all
  end

  def new
    authorize Exercise, :new?
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
    @exercise = Exercise.find(params[:id])
    authorize @exercise

    @solution = @exercise.solutions.find { |s| s.users.include?(current_user) && !s.finished? }

    if current_user.teacher?
      @solutions = @exercise.solutions
    elsif current_user.student?
      @solutions = @exercise.solutions.find_all { |s| s.users.include?(current_user) && s.finished? }
    end
  end

  def start
    if current_user.solutions.where(finished_at: nil).empty?
      @exercise = Exercise.find(params[:exercise_id])
      authorize @exercise
      @solution = Solution.create(
          exercise: @exercise,
          users: [current_user])
      redirect_to solution_path(@solution.id)
    else
      flash[:alert] = "No se puede iniciar una resolución con otra en curso"
      redirect_to exercises_path
    end
  end

  private
  def exercise_params
    params[:exercise].permit(:name, :url, :notes)
  end
end
