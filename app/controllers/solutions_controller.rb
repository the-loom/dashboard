class SolutionsController < ApplicationController
  def show
    @solution = current_user.solutions.find(params[:id])
    authorize @solution
    if @solution.finished?
      flash[:alert] = "No se puede volver a trabajar en una solución finalizada"
      redirect_to exercise_path(@solution.exercise)
      nil
    end
  end

  def summary
    @solution = current_user.solutions.find(params[:solution_id])
    authorize @solution

    @presenter = SolutionSummaryPresenter.new(@solution)
  end

  def add_partner
    @solution = current_user.solutions.find(params[:solution_id])
    authorize @solution
    @partner = User.where(nickname: params[:nickname])
    @solution.users << @partner

    redirect_to solution_path(@solution)
  end

  def start
    solution = current_user.solutions.find(params[:solution_id])
    # authorize solution
    render json: SolutionPresenter.new(solution).to_json
  end

  def finish
    solution = current_user.solutions.find(params[:solution_id])
    authorize solution

    solution.timers.detect { |timer| timer.running? }.try(:pause)
    solution.notes = params[:solution][:notes]
    solution.finished_at = Time.zone.now
    solution.save
    redirect_to exercises_path
  end

  def cancel
    solution = current_user.solutions.find(params[:solution_id])
    authorize solution
    solution.destroy
    redirect_to exercise_url(solution.exercise)
  end
end
