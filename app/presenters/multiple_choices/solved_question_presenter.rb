class MultipleChoices::SolvedQuestionPresenter
  attr_reader :question, :answers, :correct

  delegate :wording, to: :question

  def initialize(question, randomizer, response)
    @question = question
    @answers = question.answers.shuffle(random: randomizer).map { |a|
      chosen = a.id == response.answer.id
      MultipleChoices::SolvedAnswerPresenter.new(a, chosen)
    }
    @correct = question.correct_answer.id == response.answer.id
  end
end
