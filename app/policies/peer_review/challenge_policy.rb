class PeerReview::ChallengePolicy < ApplicationPolicy
  def index?
    user.teacher? || user.student?
  end
  def show?
    user.teacher? || record.enabled?
  end
  def review?
    solution = record.solution_by user
    record.enabled? && (user.teacher? || user.student?) && solution.present? && solution.final?
  end
  def manage?
    user.teacher?
  end
end
