class ExercisePolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end

  def index?
    user.teacher? || user.student?
  end

  def show?
    user.teacher? || user.student?
  end

  def new?
    user.teacher?
  end

  def create?
    user.teacher?
  end

  def start?
    user.teacher? || user.student?
  end
end
