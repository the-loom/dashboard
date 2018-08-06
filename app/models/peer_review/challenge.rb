class PeerReview::Challenge < ApplicationRecord
  include CourseLock

  validates_presence_of :title, :difficulty, :instructions,
                        :reviewer_instructions

  has_many :solutions, foreign_key: :peer_review_challenge_id
  has_many :reviews, through: :solutions

  def solution_by(user)
    solutions.where(author: user).first
  end

  def already_solved_by?(user)
    solution_by(user).present?
  end
end
