class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  helper_method :current_user
  before_action :authenticate_user!, unless: proc { pages_controller? || :repos_api? }
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :_set_current_session

  protected
    def _set_current_session
      accessor = instance_variable_get(:@_request)
      ActiveRecord::Base.send(:define_method, "session", proc { accessor.session })
      Course.current = Course.find(session[:course_id]) if session[:course_id].present?
    end

    def verify_pending_solutions
      if session[:course_id] && current_user.solutions.detect { |s| s.finished_at == nil }
        flash[:info] = "Tenés un ejercicio en curso. Si lo olvidaste, podés accederlo y finalizarlo. O eliminarlo"
      end
    end

  private

    def user_not_authorized
      flash[:alert] = "No estás autorizado a realizar esa acción"
      redirect_to(request.referrer || profile_path)
    end

    def authenticate_user!
      unless current_user
        redirect_to root_path
      end
    end

    def pages_controller?
      controller_path.starts_with?("pages") || controller_path.starts_with?("sessions")
    end

    def repos_api?
      controller_path.starts_with?("repos")
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
end
