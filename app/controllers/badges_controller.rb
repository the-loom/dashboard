class BadgesController < ApplicationController
  def index
    authorize Badge
    @badges = Badge.all
  end

  def show
    authorize Badge
    @badge = Badge.find(params[:badge_id])
    @students = User.student.sorted
  end

  def register
    authorize Badge
    badge = Badge.find(params[:badge_id])
    student = User.where(nickname: params[:nickname]).first if params[:nickname]
    student.earn(badge)
    flash[:info] = "Se asignó correctamente el emblema #{badge.name} a #{student.name}"
    redirect_to badge_details_url(badge.id)
  end

  def new
    authorize Badge, :create?
    @badge = Badge.new
  end

  def create
    authorize Badge, :create?
    @badge = Badge.new(badge_params)
    if @badge.save
      flash[:notice] = "Se creo correctamente el emblema"
    end
    redirect_to badges_list_url
  end

  private
  def badge_params
    params[:badge].permit(:name, :description, :slug)
  end
end
