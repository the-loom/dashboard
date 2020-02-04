class TinyCards::DeckPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def access?
    user.student? || user.teacher?
  end
end
