class MultipleChoices::Questionnaire < ApplicationRecord
  include CourseLock
  include Publishable

  has_many :questions, foreign_key: :multiple_choices_questionnaire_id, dependent: :destroy
  has_many :solutions, foreign_key: :multiple_choices_questionnaire_id, dependent: :destroy

  validates_presence_of :name

  accepts_nested_attributes_for :questions, allow_destroy: true

  scope :enabled, -> { where(enabled: true) }

  def solved_by?(user)
    solutions.where(solver: user).exists?
  end

  def progress_by?(user)
    solution = solutions.where(solver: user).order(created_at: :desc).first || MultipleChoices::NullSolution.new
    solution.score.to_f / 100
  end
end
