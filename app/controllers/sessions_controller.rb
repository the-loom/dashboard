class SessionsController < ApplicationController
  def admin
    unless Rails.env.development?
      redirect_to(root_url) && return
    end

    user = User.where(admin: true).first
    login_user(user)
  end

  def create
    auth = request.env["omniauth.auth"]

    identity = Identity.by_omniauth(auth)
    user = identity.user
    login_user(user)
  end

  def destroy
    session[:user_id] = session[:course_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    flash[:error] = "No pudimos verificar tu identidad. Intentalo nuevamente..."
    redirect_to root_url
  end
end
