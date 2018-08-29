class PeerReview::ReviewPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
end
