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

  private
    def login_user(user)
      memberships = user.memberships

      session[:user_id] = user.id
      if memberships.count >= 1

        if user.last_visited_course_id > 0
          session[:course_id] = user.last_visited_course_id
        else
          session[:course_id] = memberships.first.course_id
        end

        redirect_to profile_url, notice: "Signed in!"
      elsif memberships.count == 0
        redirect_to courses_url
      end
    end
end
