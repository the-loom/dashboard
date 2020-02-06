class MultipleChoices::Questionnaire < ApplicationRecord
  include CourseLock

  has_many :questions, foreign_key: :multiple_choices_questionnaire_id, dependent: :destroy

  validates_presence_of :name

end
