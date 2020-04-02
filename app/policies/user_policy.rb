class UserPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def show?
    team = record.current_membership.try(:team)
    user.teacher? || (team && team.members.include?(user)) || record == user
  end
  def promote?
    user.teacher?
  end
  def index?
    user.teacher?
  end
  def update?
    user.teacher? || user == record
  end
  def impersonate?
    user.admin?
  end
  def comment?
    user.teacher?
  end
end
