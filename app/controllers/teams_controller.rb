class TeamsController < ApplicationController

  def index
    authorize Team
    @teams = Team.all
  end

  def show
    @team = Team.where(nickname: params[:nickname]).first if params[:nickname]
    authorize @team
  end
end
