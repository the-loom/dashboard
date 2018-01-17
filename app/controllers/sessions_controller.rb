class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    identity = Identity.by_omniauth(auth)
    session[:user_id] = identity.user.id
    redirect_to profile_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

end
