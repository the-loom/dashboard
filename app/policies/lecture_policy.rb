class LecturePolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def summary?
    user.teacher?
  end
  def register?
    user.teacher?
  end
  def create?
    user.teacher?
  end
  def show?
    user.teacher?
  end
  def index?
    user.teacher?
  end
end
