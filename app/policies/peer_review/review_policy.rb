class PeerReview::ReviewPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def assess?
    user.teacher?
  end
  def message?
    user.teacher? || record.reviewer == user || record.solution.author == user
  end
end
