class MenuPresenter
  attr_reader :min_points, :max_points

  def initialize(current_user)
    @current_user = current_user
  end

  def present
    route = Rails.application.routes.url_helpers
    return [] unless @current_user && @current_user.current_membership
    x = []
    if @current_user.admin?
      x << MenuNode.new("Administración", [
          MenuLeaf.new("Usuarios", route.admin_users_path),
          MenuLeaf.new("Cursos", route.admin_courses_path)
      ])
    end

    # TODO: fix this policies
    if true || (policy(User).manage? && policy(Team).manage? && policy(Lecture).manage?)
      node = MenuNode.new("Aula", [
          MenuLeaf.new("Docentes", route.teachers_path),
          MenuLeaf.new("Estudiantes", route.students_path)
      ])

      node.leafs << MenuLeaf.new("Equipos", route.teams_path) if Course.current.on?(:teams)
      node.leafs << MenuLeaf.new("Clases", route.lectures_path) if Course.current.on?(:lectures)

      node.leafs << MenuSeparator.new

      node.leafs << MenuLeaf.new("Resumen de Asistencia", route.overview_lectures_path)

      x << node
    end
    x
  end
end

class MenuNode
  attr_reader :title, :leafs
  def initialize (title, leafs)
    @title = title
    @leafs = leafs
  end
  def node?
    true
  end
  def separator?
    false
  end
end

class MenuLeaf
  attr_reader :title, :link
  def initialize (title, link)
    @title = title
    @link = link
  end
  def node?
    false
  end
  def separator?
    false
  end
end

class MenuSeparator
  def node?
    false
  end
  def separator?
    true
  end
end
