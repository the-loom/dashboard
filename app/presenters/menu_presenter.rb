class MenuPresenter
  include Pundit

  def initialize(current_user)
    @current_user = current_user
  end

  def route
    @route ||= Rails.application.routes.url_helpers
  end

  def present
    return [] unless @current_user && @current_user.current_membership

    [
        admin_menu,
        teacher_menu,
        gamification_menu,
        dashboard_menu,
        resources_menu,
        exercises_menu,
        notifications_menu,
        courses_menu,
        profile_menu
    ].compact
  end

  private
    def profile_menu
      MenuNode.new(@current_user.short_name, [
          MenuLeaf.new("Perfil", route.profile_path),
          MenuLeaf.new("Editar perfil", route.edit_profile_path),
          MenuSeparator.new,
          MenuLeaf.new("Salir", route.logout_path)
      ])
    end

    def courses_menu
      courses_node = MenuNode.new(Course.current.name)
      if @current_user.teacher?
        courses_for_user = @current_user.all_courses
      else
        courses_for_user = @current_user.courses
      end
      courses_for_user.order(enabled: :desc, name: :asc).each do |course|
        courses_node << MenuLeaf.new(course.name, route.switch_course_path(course), (!course.enabled? ? "text-decoration: line-through" : nil))
      end
      courses_node << MenuSeparator.new
      courses_node << MenuLeaf.new("Otros cursos", route.courses_path)
      courses_node
    end

    def notifications_menu
      MenuNotification.new(@current_user, route.notifications_path)
    end

    def exercises_menu
      if on?(:multiple_choices) || on?(:tiny_cards) || on?(:automatic_correction_challenges) || on?(:peer_review_challenges) || on?(:exercises)
        exercises_node = MenuNode.new("Ejercitación")
        exercises_node << MenuLeaf.new("Tarjetas", route.tiny_cards_decks_path) if on?(:tiny_cards)
        exercises_node << MenuLeaf.new("Preguntas de Opción Múltiple", route.multiple_choices_questionnaires_path) if on?(:multiple_choices)
        exercises_node << MenuLeaf.new("Desafíos de Corrección Automática", route.repos_path) if on?(:automatic_correction_challenges)
        exercises_node << MenuLeaf.new("Desafíos de Revisión", route.peer_review_challenges_path) if on?(:peer_review_challenges)
        exercises_node << MenuLeaf.new("Ejercicios", route.exercises_path) if on?(:exercises)
        exercises_node
      end
    end

    def resources_menu
      MenuLeaf.new("Recursos", route.resources_path) if on?(:resources)
    end

    def dashboard_menu
      MenuLeaf.new("Tablero", route.dashboard_index_path)
    end

    def gamification_menu
      if on?(:events) || on?(:badges) || on?(:competences)
        gamification_node = MenuNode.new("Gamificación")
        gamification_node << MenuLeaf.new("Eventos", route.events_path) if on?(:events)
        gamification_node << MenuLeaf.new("Competencias", route.competence_tags_path) if on?(:competences)
        gamification_node << MenuLeaf.new("Emblemas", route.badges_path) if on?(:badges)
        gamification_node << MenuSeparator.new
        gamification_node << MenuLeaf.new("Estadísticas", route.points_stats_path)
        gamification_node
      end
    end

    def teacher_menu
      if manage?(User) && manage?(Team) && manage?(Lecture)
        classroom_node = MenuNode.new("Aula")
        classroom_node << MenuLeaf.new("Docentes", route.teachers_path)
        classroom_node << MenuLeaf.new("Estudiantes", route.students_path)
        classroom_node << MenuLeaf.new("Equipos", route.teams_path) if on?(:teams)
        if on?(:lectures)
          classroom_node << MenuLeaf.new("Clases", route.lectures_path)
          classroom_node << MenuSeparator.new
          classroom_node << MenuLeaf.new("Resumen de Asistencia", route.overview_lectures_path)
        end
        classroom_node
      end
    end

    def admin_menu
      if @current_user.admin?
        MenuNode.new("Administración", [
            MenuLeaf.new("Usuarios", route.admin_users_path),
            MenuLeaf.new("Cursos", route.admin_courses_path)
        ])
      end
    end

    def on?(feature)
      Course.current.on?(feature)
      end

    def policy?(entity, policy)
      Pundit.policy(@current_user, entity).send(policy)
    end

    def manage?(entity)
      policy?(entity, :manage?)
    end
end

class MenuNode
  attr_reader :title, :leafs
  def initialize (title, leafs = [])
    @title = title
    @leafs = leafs
  end
  def <<(leaf)
    @leafs << leaf
  end
end

class MenuLeaf
  attr_reader :title, :link, :style
  def initialize (title, link, style = "")
    @title = title
    @link = link
    @style = style
  end
end

class MenuSeparator
end

class MenuNotification
  attr_reader :counter, :link
  def initialize(user, link)
    @counter = user.current_membership.unread_notifications
    @link = link
  end
  def show_badge?
    @counter > 0
  end
end