class MultipleChoices::Answer < ApplicationRecord
  belongs_to :question, foreign_key: :multiple_choices_question_id, optional: true
  has_many :responses, foreign_key: :multiple_choices_answer_id

  validates :text, presence: true
end
