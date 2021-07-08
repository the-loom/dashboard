class LecturePolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def overview?
    user.teacher?
  end
  def self_register?
    user.student? || user.teacher?
  end
  def register?
    user.teacher?
  end
  def quick_register?
    user.admin?
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
