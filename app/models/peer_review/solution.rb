class PeerReview::Solution < ApplicationRecord
  belongs_to :challenge, foreign_key: :peer_review_challenge_id
  belongs_to :author, foreign_key: :author_id, class_name: "User"

  has_many :reviews, foreign_key: :peer_review_solution_id, dependent: :delete_all

  enum status: {
      draft: 0,
      final: 1
  }

  def publish!
    self.status = :final
  end

  def review_by(reviewer)
    reviews.where(reviewer: reviewer).first
  end

  def size
    length = wording && wording.size || 0
    "%.2f Kb" % (length / 1024.0)
  end
end
