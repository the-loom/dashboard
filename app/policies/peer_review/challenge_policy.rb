class PeerReview::ChallengePolicy < ApplicationPolicy
  def index?
    user.teacher? || user.student?
  end
  def show?
    user.teacher? || user.student?
  end
  def solve?
    record.enabled?
  end
  def review?
    record.reviewable_by? user
  end
  def manage?
    user.teacher?
  end
  def purge?
    user.admin?
  end
end
