class MultipleChoices::Questionnaire < ApplicationRecord
  include CourseLock
  include Publishable

  has_many :questions, foreign_key: :multiple_choices_questionnaire_id, dependent: :destroy
  has_many :solutions, foreign_key: :multiple_choices_questionnaire_id, dependent: :destroy

  validates_presence_of :name
end
