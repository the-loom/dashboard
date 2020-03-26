class PeerReview::Challenge < ApplicationRecord
  include CourseLock
  include Publishable

  validates_presence_of :title, :difficulty, :instructions,
                        :reviewer_instructions
  validates :difficulty, inclusion: { in: 1..5, message: "must be between 1 and 5" }
  
  has_many :solutions, foreign_key: :peer_review_challenge_id
  has_many :reviews, through: :solutions

  enum challenge_mode: {
      student_and_teacher_reviews: 0,
      student_reviews_only: 1,
      teacher_reviews_only: 2
  }

  scope :enabled, -> { where(enabled: true) }
  
  def solution_by(user)
    solutions.find_by(author: user)
  end

  def already_solved_by?(user)
    solution = solution_by(user)
    solution && solution.final?
  end

  def solvers
    solutions.includes(:author).map(&:author).uniq.compact
  end

  def reviewers
    reviews.includes(:reviewer).map(&:reviewer).uniq.compact
  end

  def solvable_by?(user)
    !already_solved_by?(user) || user.teacher?
  end

  def reviewable_by?(user)
    if user.teacher?
      return true if [:student_and_teacher_reviews, :teacher_reviews_only].include? self.challenge_mode.to_sym
    else
      return true if [:student_and_teacher_reviews, :student_reviews_only].include?(self.challenge_mode.to_sym) && already_solved_by?(user)
    end
    false
  end
end
