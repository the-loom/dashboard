class TeamPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def index?
    user.teacher?
  end
  def show?
    user.teacher? || record.members.include?(user)
  end

  def create?
    user.teacher?
  end

  def add_member?
    user.teacher?
  end
end
