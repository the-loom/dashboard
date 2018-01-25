class AutomaticCorrection::RepoPolicy < ApplicationPolicy
  def index?
    user.teacher? || user.student?
  end
end
