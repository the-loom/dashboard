class MultipleChoices::PracticeQuestionnairePresenter
  attr_reader :questionnaire, :questions

  delegate :question_ids, to: :questionnaire
  delegate :name, to: :questionnaire

  def initialize(questionnaire, randomizer)
    @questionnaire = questionnaire
    @questions = questionnaire.questions.shuffle(random: randomizer).map { |q| MultipleChoices::PracticeQuestionPresenter.new(q, randomizer) }
  end
end
