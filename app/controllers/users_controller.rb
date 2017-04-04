class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]

  def index
    authorize User
    @students = User.student.sorted
  end

  def show
    @user = User.where(nickname: params[:nickname]).first if params[:nickname]
  end

  def impersonate
    @user = User.where(nickname: params[:nickname]).first
    authorize current_user, :impersonate?
    session[:user_id] = @user.id
    redirect_to profile_url
  end

  def edit
  end

  def update
    @user.update(user_params)
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
