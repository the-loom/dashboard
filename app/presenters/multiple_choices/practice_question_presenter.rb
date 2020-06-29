class MultipleChoices::PracticeQuestionPresenter
  attr_reader :question, :answers

  delegate :id, to: :question
  delegate :wording, to: :question

  def initialize(question, randomizer)
    @question = question
    @answers = question.answers.shuffle(random: randomizer)
  end
end
