class PeerReview::Solution < ApplicationRecord

  belongs_to :challenge, foreign_key: :peer_review_challenge_id
  belongs_to :author, foreign_key: :author_id, class_name: 'User'

  enum status: {
      draft: 0,
      final: 1
  }

end
