class PeerReview::Challenge < ApplicationRecord
  include CourseLock

  validates_presence_of :title, :difficulty, :instructions,
                        :reviewer_instructions

  has_many :solutions, foreign_key: :peer_review_challenge_id

end
