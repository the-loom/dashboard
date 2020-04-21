class PeerReview::SolutionPolicy < ApplicationPolicy
  def manage?
    user.teacher?
  end
  def solve?
    (user.teacher? || user.student?) && record.draft?
  end
  def unpublish?
    (record.author == user && record.unpublishable?) || user.teacher? && record.status.to_sym == :final
  end
end
