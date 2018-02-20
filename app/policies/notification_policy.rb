class NotificationPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end

  def index?
    user.student? || user.teacher?
  end

  def new?
    user.teacher?
  end

  def create?
    user.teacher?
  end
end
