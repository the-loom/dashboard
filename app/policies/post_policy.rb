class PostPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
end
