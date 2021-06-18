class ExercisePolicy < ApplicationPolicy
  def manage?
    user.teacher? && Course.current.editable?
  end

  def index?
    user.teacher? || user.student?
  end

  def show?
    user.teacher? || user.student?
  end
end
