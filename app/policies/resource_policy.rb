class ResourcePolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end

  def use?
    user.teacher? || user.student?
  end
end
