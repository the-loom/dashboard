class TeamPolicy < ApplicationPolicy
  def index?
    user.teacher?
  end
  def show?
    user.teacher? || record.users.include?(user)
  end
end
