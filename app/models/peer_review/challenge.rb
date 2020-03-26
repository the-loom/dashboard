class PeerReview::Challenge < ApplicationRecord
  include CourseLock
  include Publishable

  validates_presence_of :title, :difficulty, :instructions,
                        :reviewer_instructions
  validates :difficulty, inclusion: { in: 1..5, message: "must be between 1 and 5" }
  
  has_many :solutions, foreign_key: :peer_review_challenge_id
  has_many :reviews, through: :solutions

  scope :enabled, -> { where(enabled: true) }
  
  def solution_by(user)
    solutions.find_by(author: user)
  end

  def already_solved_by?(user)
    solution_by(user).present?
  end

  def solvers
    solutions.includes(:author).map(&:author).uniq.compact
  end

  def reviewers
    reviews.includes(:reviewer).map(&:reviewer).uniq.compact
  end
end
