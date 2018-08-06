class PeerReview::Review < ApplicationRecord
  belongs_to :solution, foreign_key: :peer_review_solution_id
  delegate :challenge, to: :solution
  belongs_to :reviewer, foreign_key: :reviewer_id, class_name: "User"

  enum status: {
      draft: 0,
      final: 1
  }

  def publish!
    self.status = :final
  end
end
