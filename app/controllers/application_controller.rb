class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  helper_method :current_user
  before_action :authenticate_user!, unless: proc { pages_controller? || repos_api? }
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :_set_current_session
  before_action :set_raven_context

  protected
    def set_raven_context
      Raven.user_context(id: session[:user_id])
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end


    def _set_current_session
      accessor = instance_variable_get(:@_request)
      ActiveRecord::Base.send(:define_method, "session", proc { accessor.session })
      Course.current = Course.find_by(id: session[:course_id]) if session[:course_id].present?
      end

    def verify_name
      if !current_user.first_name.present? || current_user.first_name.strip.empty?
        flash[:alert] = "Por favor, utilizá tu nombre completo en el perfil. Podés hacerlo desde la barra de menú"
      end
    end

  private
    def check_feature(feature)
      unless Course.current.on?(feature)
        flash[:alert] = "Esa característica no está habilitada para este curso"
        redirect_to(request.referrer || profile_path)
      end
    end

    def user_not_authorized
      flash[:alert] = "No estás autorizado a realizar esa acción"
      redirect_to(request.referrer || profile_path)
    end

    def authenticate_user!
      unless current_user
        redirect_to(root_path) && (return)
      end
      unless controller_path == "courses" || current_user.memberships.enabled.size > 0
        flash[:info] = "Aún no pertenecés a ningún curso. Podés inscribirte desde aquí"
        redirect_to(courses_path) && (return)
      end
    end

    def pages_controller?
      controller_path.starts_with?("pages") || controller_path.starts_with?("sessions")
    end

    def repos_api?
      controller_path.starts_with?("api")
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
end
