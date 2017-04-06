class EventPolicy < ApplicationPolicy
  def register?
    user.teacher?
  end
  def show?
    user.teacher?
  end
  def index?
    user.teacher?
  end
end
