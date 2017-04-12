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
end
