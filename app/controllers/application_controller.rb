class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  before_filter :authenticate_user!, unless: :pages_controller?

  private

  def authenticate_user!
    unless current_user
      redirect_to root_path
    end
  end

  def pages_controller?
    controller_path.starts_with?("pages") || controller_path.starts_with?("sessions")
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
