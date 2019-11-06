class TeamPolicy < ApplicationPolicy
  def manage?
    user.teacher? || record.members.include?(user)
  end
  def index?
    user.teacher?
  end

  def create?
    user.teacher?
  end

  def add_member?
    user.teacher?
  end
end
