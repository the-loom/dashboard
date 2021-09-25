class MultipleChoices::QuestionnaireGraph
  def initialize(questionnaire)
    @questionnaire = questionnaire
  end

  def total_responses
    @total_responses ||= @questionnaire.solutions.count
  end

  def correct_responses
    result = ["B"]
    @questionnaire.questions.each do |q|
      stats = MultipleChoices::QuestionStats.new(q)
      result << (stats.correct_answers.to_f / total_responses).round(2)
    end
    result.to_json
  end

  def incorrect_responses
    result = ["M"]
    @questionnaire.questions.each do |q|
      stats = MultipleChoices::QuestionStats.new(q)
      result << (stats.incorrect_answers.to_f / total_responses).round(2)
    end
    result.to_json
  end

  def for(answer)
    @responses_by_answer_id[answer.id] ||= answer.responses.count
    "#{((@responses_by_answer_id[answer.id] / total_responses.to_f) * 100).round(2)} %"
  end
end
