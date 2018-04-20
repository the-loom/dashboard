class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :change_identity]
  before_action :verify_pending_solutions, only: :show
  before_action :verify_name, only: :show

  def index
    authorize User
    @students = Course.current.memberships.student.collect { |x| x.user }
  end

  def guests
    authorize User
    @guests = Course.current.memberships.guest.collect { |x| x.user }
  end

  def show
    if params[:nickname]
      unless @user = Course.current.memberships.includes(:user).where(users: { nickname: params[:nickname] }).first.try(:user)
        flash[:alert] = "No existe el usuario"
        return redirect_to "/"
      end
    else
      @user = current_user
    end
    @missing_badges = Badge.all - @user.badges
    authorize @user
  end

  def comment
    unless @user = Course.current.memberships.includes(:user).where(users: { nickname: params[:nickname] }).first.try(:user)
      flash[:alert] = "No existe el usuario"
      return redirect_to "/"
    end
    authorize @user, :comment?
    @user.comments.create(body: params[:comment][:body], commenter: current_user, mood: params[:comment][:mood].to_i)
    redirect_to user_details_url(@user.nickname)
  end

  def impersonate
    @user = User.where(nickname: params[:nickname]).first
    authorize @user, :impersonate?
    session[:user_id] = @user.id
    redirect_to profile_url
  end

  def edit
    authorize @user, :update?
  end

  def update
    authorize @user, :update?
    if @user.update(user_params)
      redirect_to profile_url
    else
      render :edit
    end
  end

  def change_identity
    authorize @user, :update?
    identity = @user.identities.where(id: params[:identity_id]).first
    @user.update_with(identity)
    redirect_to profile_url
  end

  def bulk_edit
    if params[:mark_as_guest]
      role = :guest
    elsif params[:mark_as_teacher]
      role = :teacher
    elsif params[:mark_as_student]
      role = :student
    end
    Course.current.memberships.where("user_id IN (?)", params[:students][:ids].map(&:to_i)).update_all(role: role)
    redirect_to students_url
  end

  private

    def set_user
      @user ||= current_user
    end

    def user_params
      params[:user].permit(:name)
    end
end
