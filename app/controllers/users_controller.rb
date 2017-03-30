class UsersController < ApplicationController

  def show
    @user = User.where(nickname: params[:nickname]).first if params[:nickname]
    @user ||= current_user
  end

  def card
    @user = current_user
    render :layout => false
  end

end
