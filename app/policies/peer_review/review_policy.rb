class PeerReview::ReviewPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def assess?
    user.teacher?
  end
end
