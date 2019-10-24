class TeamPolicy < ApplicationPolicy
  def manage?
    team = user.current_membership.team
    user.teacher? || team.members.include?(user)
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
