class CoursePolicy < ApplicationPolicy
  def admin?
    user.admin?
  end

  def manage?
    user.teacher?
  end

  def show?
    user.teacher? || user.student?
  end
end
