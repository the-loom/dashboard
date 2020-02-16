class MultipleChoices::QuestionnairePresenter
  attr_reader :questionnaire

  delegate :name, to: :questionnaire

  def initialize(questionnaire)
    @questionnaire = questionnaire
  end

  def to_json
    {
        name: @questionnaire.name,
        questions: @questionnaire.questions.map do |question|
          {
              wording: question.wording,
              answers: question.answers.map do |answer|
                {
                    text: answer.text,
                    correct: answer.correct,
                    explanation: answer.explanation
                }
              end
          }
        end
    }.to_json
  end
end
