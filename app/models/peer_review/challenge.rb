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

  def find_reviewable_solution_for(user)
    # TODO: rethink

    started_reviews = reviews.where(reviewer: user, status: :draft)
    return started_reviews.first unless started_reviews.empty?

    reviewed_solutions = reviews.where(reviewer: user).pluck(&:solution)
    reviewable_solutions = solutions - reviewed_solutions
    return reviewable_solutions.sample unless reviewable_solutions.empty?

    nil
  end
end
