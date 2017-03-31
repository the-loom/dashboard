class UsersController < ApplicationController

  def show
    @user = User.where(nickname: params[:nickname]).first if params[:nickname]
    @user ||= current_user
  end

  def index
    @students = User.student.sorted
  end

end
