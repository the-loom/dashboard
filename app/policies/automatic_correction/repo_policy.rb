class AutomaticCorrection::RepoPolicy < ApplicationPolicy
  def index?
    user.teacher? || user.student?
  end
  def manage?
    user.teacher?
  end
end
