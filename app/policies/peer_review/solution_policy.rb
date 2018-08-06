class PeerReview::SolutionPolicy < ApplicationPolicy
  def solve?
    (user.teacher? || user.student?) && record.draft?
  end
end
