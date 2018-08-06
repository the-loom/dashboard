class PeerReview::ChallengePolicy < ApplicationPolicy
  def index?
    user.teacher? || user.student?
  end
  def review?
    solution = record.solution_by user
    (user.teacher? || user.student?) && solution.present? && solution.final?
  end
  def manage?
    user.teacher?
  end
end
