class MultipleChoices::QuestionStats
  def initialize(question)
    @question = question
    @responses_by_answer_id = Hash.new
  end

  def total_responses
    @total ||= @question.responses.count
  end

  def for(answer)
    @responses_by_answer_id[answer.id] ||= answer.responses.count
    "#{((@responses_by_answer_id[answer.id] / total_responses.to_f) * 100).round(2)} %"
  end
end
