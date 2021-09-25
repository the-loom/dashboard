class MultipleChoices::SolvedAnswerPresenter
  attr_reader :answer, :chosen

  delegate :text, to: :answer
  delegate :explanation, to: :answer

  def initialize(answer, chosen)
    @answer = answer
    @chosen = chosen
  end

  def classes
    classes = []
    classes << "correct" if answer.correct && @chosen
    classes << "chosen selected" if @chosen
    classes.join(" ")
  end
end
