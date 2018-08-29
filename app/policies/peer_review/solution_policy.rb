class PeerReview::SolutionPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def solve?
    (user.teacher? || user.student?) && record.draft?
  end
end
