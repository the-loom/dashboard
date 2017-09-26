class TimersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def play
    solution = Solution.find(params[:solution_id])
    authorize solution, :timer?
    if params[:timer_id].to_i == 0 # FEO
      timer = Timer.create(solution: solution, stage: params[:stage].to_i, description: params[:description])
    else
      timer = Timer.find(params[:timer_id].to_i)
    end
    timer.estimated_time_in_seconds = params[:estimated_time_in_seconds].to_i unless timer.estimated_time_in_seconds
    timer.play
    timer.save

    render json: TimerPresenter.new(timer).to_json
  end

  def pause
    solution = Solution.find(params[:solution_id])
    authorize solution, :timer?
    timer = Timer.find(params[:timer_id].to_i)
    timer.pause
    timer.save

    render json: TimerPresenter.new(timer).to_json
  end
end
