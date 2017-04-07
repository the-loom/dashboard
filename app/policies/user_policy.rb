class UserPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def index?
    user.teacher?
  end
  def update?
    user.teacher?
  end
  def impersonate?
    user.teacher?
  end
end
