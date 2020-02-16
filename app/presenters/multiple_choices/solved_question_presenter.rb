class MultipleChoices::SolvedQuestionPresenter
  attr_reader :question, :answers, :correct

  delegate :wording, to: :question

  def initialize(question, answer)
    @question = question
    @answers = question.answers.map { |a|
      chosen = a.id == answer[:answer].to_i
      MultipleChoices::SolvedAnswerPresenter.new(a, chosen)
    }
    @correct = question.correct_answer.id == answer[:answer].to_i
  end

end
