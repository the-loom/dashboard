class MultipleChoices::Question < ApplicationRecord
  include CourseLock

  has_many :answers, foreign_key: :multiple_choices_question_id, dependent: :destroy

  validates_presence_of :wording

  def correct_answer
    answers.find_by(correct: true)
  end
end
