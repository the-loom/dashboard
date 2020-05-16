class MultipleChoices::Response < ApplicationRecord
  belongs_to :solution, foreign_key: :multiple_choices_solution_id
  belongs_to :question, foreign_key: :multiple_choices_question_id
  belongs_to :answer, foreign_key: :multiple_choices_answer_id
end
