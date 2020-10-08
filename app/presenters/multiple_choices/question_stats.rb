class MultipleChoices::QuestionStats
  def initialize(question)
    @question = question
  end

  def total_responses
    @total ||= @question.responses.count
  end

  def for(answer)
    "#{((answer.responses.count / total_responses.to_f) * 100).round(2)} %"
  end
end
