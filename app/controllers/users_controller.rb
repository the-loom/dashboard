class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :change_identity]
  before_action :verify_pending_solutions, only: :show

  def index
    authorize User
    @students = User.student.sorted
  end

  def guests
    authorize User
    @guests = User.guest.sorted
  end

  def show
    @user = User.where(nickname: params[:nickname]).first if params[:nickname]
    @missing_badges = Badge.all - @user.badges
    authorize @user
  end

  def comment
    @user = User.where(nickname: params[:nickname]).first
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
    @user.update(user_params)
    redirect_to profile_url
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
    User.where("id IN (?)", params[:students][:ids].map(&:to_i)).update_all(role: role)
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
