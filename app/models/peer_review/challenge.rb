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

  def due?
    return false unless due_date
    Time.zone.now > self.due_date + 1.day
  end

  def disable!
    self.update_attribute(:enabled, false)
  end

  def solution_by(user)
    solutions.find_by(author: user)
  end

  def already_solved_by?(user)
    solution = solution_by(user)
    solution && solution.final?
  end

  def progress_by?(user)
    progress = 0.0

    # solved?
    progress += 1 if already_solved_by?(user)

    return progress / 1 if teacher_reviews_only?
    # reviewed?
    progress += solutions.includes(:reviews).includes(reviews: :reviewer)
                    .where(peer_review_reviews: { status: 1 }) # :final == 1
                    .where(peer_review_reviews: { reviewer_id: user.id})
                    .count

    progress / (expected_reviews + 1)
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
