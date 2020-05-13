class MultipleChoices::Solution < ApplicationRecord
  include CourseLock

  belongs_to :questionnaire, foreign_key: :multiple_choices_questionnaire_id
  belongs_to :solver, foreign_key: :user_id, class_name: "User"

  has_many :responses, foreign_key: :multiple_choices_solution_id, dependent: :destroy

  def refresh_score!
    self.score = (responses.where(correct: true).count / responses.count.to_f) * 100
    save
  end
end
