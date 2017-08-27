class TimersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def play
    solution = Solution.find(params[:solution_id])
    authorize solution, :timer?
    # TODO(delucas): ojo con las subetapas
    timer = Timer.where(solution: solution, stage: params[:timer_id]).first
    timer.estimated_time_in_seconds = params[:estimated_time_in_seconds].to_i unless timer.estimated_time_in_seconds
    timer.play
    render json: TimerPresenter.new(timer).to_json
  end

  def pause
    solution = Solution.find(params[:solution_id])
    authorize solution, :timer?
    # TODO(delucas): ojo con las subetapas
    timer = Timer.where(solution: solution, stage: params[:timer_id]).first
    timer.pause
    render json: TimerPresenter.new(timer).to_json
  end
end
