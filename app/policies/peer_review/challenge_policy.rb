class PeerReview::ChallengePolicy < ApplicationPolicy
  def index?
    user.teacher? || user.student?
  end
  def solve?
    user.teacher? || user.student?
  end
  def review?
    user.teacher? || user.student?
  end
  def manage?
    user.teacher?
  end
end
