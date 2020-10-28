class MultipleChoices::SolvedQuestionnairePresenter
  attr_reader :questionnaire, :questions

  delegate :name, to: :questionnaire

  def initialize(questionnaire, randomizer, solution)
    @questionnaire = questionnaire
    @questions = questionnaire.questions.visible.shuffle(random: randomizer).map { |q|
      response = solution.responses.find_by(question: q)
      MultipleChoices::SolvedQuestionPresenter.new(q, randomizer, response)
    }
  end

  def points
    @questions.select { |x| x.correct }.count
  end

  def total_points
    @questions.size
  end
end
