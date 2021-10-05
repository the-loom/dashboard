class Serializers::MultipleChoiceQuestionnaireSerializer
  def self.serialize(questionnaire)
    q = questionnaire
    {
      name: q.name,
      single_use: q.single_use,
      questions: q.questions.map do |qs|
        {
          wording: qs.wording,
          answers: qs.answers.map do |an|
            {
              text: an.text,
              correct: an.correct,
              explanation: an.explanation
            }
          end
        }
      end
    }
  end

  def self.deserialize(json_string)
    qh = JSON.parse(json_string).deep_symbolize_keys

    questionnaire = MultipleChoices::Questionnaire.new(name: qh[:name], single_use: qh[:single_use])
    qh[:questions].each do |q|
      question = MultipleChoices::Question.new(wording: q[:wording])
      q[:answers].each do |a|
        answer = MultipleChoices::Answer.new(text: a[:text], correct: a[:correct], explanation: a[:explanation])
        question.answers << answer
      end
      questionnaire.questions << question
    end

    questionnaire.published = false
    questionnaire.enabled = false
    questionnaire
  end
end
