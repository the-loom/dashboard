class MultipleChoices::Question < ApplicationRecord
  has_many :answers, foreign_key: :multiple_choices_question_id, dependent: :destroy
  has_many :responses, foreign_key: :multiple_choices_question_id, dependent: :destroy

  validates_presence_of :wording

  accepts_nested_attributes_for :answers, allow_destroy: true

  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }

  def correct_answer
    answers.find_by(correct: true)
  end
end
