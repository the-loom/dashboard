class CheckpointsController < ApplicationController

  def index
    authorize Checkpoint
    @checkpoints = Checkpoint.all
  end

  def show
    authorize Checkpoint
    @checkpoint = Checkpoint.find(params[:checkpoint_id])
    @teams = Team.sorted
  end

  def register
    authorize Checkpoint
    check = Check.create(check_params)
    flash[:info] = "Se guardó correctamente la entrega #{check.checkpoint.name} para #{check.team.name}"
    redirect_to checkpoint_details_url(check.checkpoint.id)
  end

  def new
    authorize Checkpoint, :create?
    @checkpoint = Checkpoint.new
  end

  def create
    authorize Checkpoint, :create?
    @checkpoint = Checkpoint.new(checkpoint_params)
    if @checkpoint.save
      flash[:notice] = "Se creo correctamente la entrega"
    end
    redirect_to checkpoints_list_url
  end

  private
  def checkpoint_params
    params[:checkpoint].permit(:name, :link, :due_date)
  end

  def check_params
    params[:check][:condition] = params[:check][:condition].to_i
    params[:check].permit(:team_id, :checkpoint_id, :comments, :condition)
  end
end
