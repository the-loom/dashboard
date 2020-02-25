class MultipleChoices::Question < ApplicationRecord
  has_many :answers, foreign_key: :multiple_choices_question_id, dependent: :destroy

  validates_presence_of :wording

  accepts_nested_attributes_for :answers, allow_destroy: true

  def correct_answer
    answers.find_by(correct: true)
  end
end
