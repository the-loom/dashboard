class MultipleChoices::Answer < ApplicationRecord
  belongs_to :question, foreign_key: :multiple_choices_question_id

  validates :text, presence: true
end
