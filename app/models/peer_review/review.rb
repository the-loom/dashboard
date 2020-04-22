class PeerReview::Review < ApplicationRecord
  belongs_to :solution, foreign_key: :peer_review_solution_id
  delegate :challenge, to: :solution
  belongs_to :reviewer, foreign_key: :reviewer_id, class_name: "User"
  belongs_to :assessor, foreign_key: :assessor_id, class_name: "User", optional: true

  validates :solution, uniqueness: { scope: :reviewer, message: "should review only once per solution" }

  enum status: {
      draft: 0,
      final: 1
  }

  enum teacher_assessment: {
      pending: 0,
      good: 1,
      bad: 2
  }

  scope :sorted, -> { order(id: :asc) }

  def publish!
    self.status = :final
  end
end
