class TeacherPolicy < Struct.new(:user, :teacher)
  def index?
    user.admin?
  end
  def destroy?
    user.teacher? || user.admin?
  end
  def show?
    user.student? || user.teacher?
  end
end
