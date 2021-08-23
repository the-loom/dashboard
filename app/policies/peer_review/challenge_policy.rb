class PeerReview::ChallengePolicy < ApplicationPolicy
  def index?
    user.teacher?
  end
  def show?
    user.teacher? || user.student? && record.published?
  end
  def solve?
    record.enabled?
  end
  def review?
    record.reviewable_by? user
  end
  def monitor?
    user.teacher?
  end
  def manage?
    user.teacher? && Course.current.editable?
  end
  def purge?
    user.admin?
  end
end
