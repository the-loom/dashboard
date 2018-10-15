class TeacherPolicy < Struct.new(:user, :teacher)
  def index?
    user.teacher? || user.admin?
  end
  def destroy?
    user.teacher? || user.admin?
  end
end
