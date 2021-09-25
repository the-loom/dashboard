class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :change_identity]
  before_action :verify_name, only: :show

  def show
    if params[:nickname]
      unless @user = Course.current.memberships.includes(:user).find_by(users: { nickname: params[:nickname] }).try(:user)
        flash[:alert] = "No existe el usuario"
        return redirect_to "/"
      end
    else
      @user = current_user
    end
    authorize @user
    @missing_badges = Badge.all - @user.badges
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
    identity = @user.identities.find_by(id: params[:identity_id])
    @user.update_with(identity)
    redirect_to profile_url
  end

  private
    def set_user
      @user ||= current_user
    end

    def user_params
      params[:user].permit(:first_name, :last_name, :avatar, :bios)
    end
end
