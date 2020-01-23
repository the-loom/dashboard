class TinyCards::CardPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def access?
    user.student?
  end
end
