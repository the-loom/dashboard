class UserPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def show?
    user.teacher? || (record.team && record.team.members.include?(user)) || record == user
  end
  def index?
    user.teacher?
  end
  def guests?
    user.teacher?
  end
  def update?
    user.teacher? || (user == record && !record.locked?)
  end
  def impersonate?
    user.teacher?
  end
  def comment?
    user.teacher?
  end
end
