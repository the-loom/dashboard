class PeerReview::Challenge < ApplicationRecord
  include CourseLock
  include Publishable

  validates_presence_of :title, :difficulty, :instructions,
                        :reviewer_instructions
  validate :difficulty_range

  has_many :solutions, foreign_key: :peer_review_challenge_id
  has_many :reviews, through: :solutions

  scope :published, -> { where(published: true) }
  scope :enabled, -> { where(enabled: true) }

  def difficulty_range
    if difficulty.present? and (difficulty < 1 or difficulty > 5)
      errors.add(:difficulty, "cannot be less than 1 or greater than 5")
    end
  end
  
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
