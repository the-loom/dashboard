class PeerReview::Challenge < ApplicationRecord
  include CourseLock
  include Publishable
  include HasDifficulty

  validates_presence_of :title, :instructions,
                        :reviewer_instructions, :solution_type
  validates_presence_of :language, if: :source_code?

  validates_numericality_of :expected_reviews, greater_than_or_equal_to: 0, only_integer: true

  validate :prevent_inconsistencies

  before_validation :expire_if_in_the_past

  serialize :rubrics, JSON

  def expire_if_in_the_past
    if due?
      disable!
    end
  end

  def prevent_inconsistencies
    errors.add(:team_challenge, "este curso no tiene la característica de grupos habilitada") if team_challenge && !course.on?(:teams)

    errors.add(:team_challenge, "una tarea grupal sólo puede ser revisado por docentes") if team_challenge && challenge_mode.to_sym != :teacher_reviews_only
    errors.add(:challenge_mode, "las tareas de revisiones rápidas sólo pueden ser revisadas por docentes") if allows_quick_reviews && challenge_mode.to_sym != :teacher_reviews_only

    unless solutions.empty?
      errors.add(:team_challenge, "no puede cambiar porque ya hay soluciones publicadas") if team_challenge_changed?
      errors.add(:solution_type, "no puede cambiar porque ya hay soluciones publicadas") if solution_type_changed?
      errors.add(:language, "no puede cambiar porque ya hay soluciones publicadas") if language_changed?
      errors.add(:optional, "no puede cambiar porque ya hay soluciones publicadas") if saved_change_to_optional?
    end

    unless reviews.empty?
      errors.add(:allows_quick_reviews, "no puede cambiar el tipo de revisiones una vez que hay revisiones publicadas") if allows_quick_reviews_changed?
    end

    if reviews.includes(reviewer: :memberships).inject(false) { |v, r| v || r.reviewer.teacher? }
      errors.add(:challenge_mode, "no puede cambiar porque ya hay revisiones de docentes publicadas") if challenge_mode.to_sym == :student_reviews_only
    end

    if reviews.includes(reviewer: :memberships).inject(false) { |v, r| v || r.reviewer.student? }
      errors.add(:challenge_mode, "no puede cambiar porque ya hay revisiones de estudiantes publicadas") if challenge_mode.to_sym == :teacher_reviews_only
    end

    if solutions.includes(solution_attachment_attachment: :blob).inject(false) { |v, s| v || s.solution_attachment.attached? }
      errors.add(:allows_attachment, "no puede dejar de recibirse adjuntos una vez que hay soluciones con adjuntos") if allows_attachment_changed? && !allows_attachment
    end
  end

  has_many :solutions, foreign_key: :peer_review_challenge_id
  has_many :reviews, through: :solutions

  has_many :picked_solutions, -> { picked }, foreign_key: :peer_review_challenge_id, class_name: "PeerReview::Solution"

  enum challenge_mode: {
      student_and_teacher_reviews: 0,
      student_reviews_only: 1,
      teacher_reviews_only: 2
  }

  enum solution_type: {
      free_text: 0,
      source_code: 1
  }

  scope :enabled, -> { where(enabled: true) }

  def code_mirror_mode
    return "text/x-java" if language == "java"
    return "text/x-c++src" if language == "cpp"
    language
  end

  def has_picked_solutions?
    !enabled? && picked_solutions.size > 0
  end

  def due?
    return false unless due_date
    Time.zone.now > self.due_date.beginning_of_day + 1.day
  end

  def needs_purge?
    self.reviews.where(status: :draft).count > 0 ||
        self.solutions.where(status: :draft).count > 0
  end

  def purge!
    self.reviews.where(status: :draft).delete_all
    self.solutions.where(status: :draft).delete_all
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

  def already_solved_by_team?(team)
    return false unless team
    team.members.inject(false) { |accum, user| accum || already_solved_by?(user) }
  end

  def progress_by?(user)
    progress = 0.0

    # solved?
    progress += 1.0 if already_solved_by?(user) || (team_challenge? && already_solved_by_team?(user.current_membership.team))

    return [progress / 1.0, 1.0].min if teacher_reviews_only? || progress == 0.0
    # reviewed?
    progress += solutions.includes(:reviews).includes(reviews: :reviewer)
                    .where(peer_review_reviews: { status: 1 }) # :final == 1
                    .where(peer_review_reviews: { reviewer_id: user.id })
                    .count

    [progress / (expected_reviews + 1.0), 1.0].min
  end

  def solvers
    solutions.includes(:author).map(&:author).uniq.compact
  end

  def reviewers
    reviews.includes(:reviewer).map(&:reviewer).uniq.compact
  end

  def solvable_by?(user)
    solved = team_challenge ? already_solved_by_team?(user.current_membership.team) : already_solved_by?(user)
    !solved || user.teacher?
  end

  def reviewable_by?(user)
    if user.teacher?
      return true if [:student_and_teacher_reviews, :teacher_reviews_only].include? self.challenge_mode.to_sym
    else
      return true if [:student_and_teacher_reviews, :student_reviews_only].include?(self.challenge_mode.to_sym) && already_solved_by?(user)
    end
    false
  end

  def self.to_csv
    challenges = PeerReview::Challenge.where(published: :true).order(title: :asc)
    students = Course.current.memberships.includes(:user).student.collect(&:user)
    CSV.generate() do |csv|
      csv << ["Apellido", "Nombre", "Grupo"] + challenges.map(&:title)
      students.each do |student|
        csv << [student.last_name, student.first_name, student.current_membership.team.try(:name)] +
                challenges.map { |challenge| challenge.solved(student) ? "Si" : "No" }
      end
    end
  end

  def solved(student)
    already_solved_by?(student) ||
    (team_challenge &&
    already_solved_by_team?(student.current_membership.team))
  end
end
