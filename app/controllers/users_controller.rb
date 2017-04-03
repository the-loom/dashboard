class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]

  def index
    @students = User.student.sorted
  end

  def show
    @user = User.where(nickname: params[:nickname]).first if params[:nickname]
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to profile_url
  end

  private

  def set_user
    @user ||= current_user
  end

  def user_params
    params[:user].permit(:name)
  end

end
