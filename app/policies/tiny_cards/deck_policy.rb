class TinyCards::DeckPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def access?
    user.student?
  end
end
