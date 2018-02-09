class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    identity = Identity.by_omniauth(auth)
    session[:user_id] = identity.user.id
    if identity.user.memberships.count >= 1
      #TODO(delucas): log into latest used course
      session[:course_id] = identity.user.courses.first.id
    end
    redirect_to profile_url, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = session[:course_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
