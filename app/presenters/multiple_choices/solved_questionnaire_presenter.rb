class MultipleChoices::SolvedQuestionnairePresenter
  attr_reader :questionnaire, :questions

  delegate :name, to: :questionnaire

  def initialize(questionnaire, answers, randomizer)
    @questionnaire = questionnaire
    @questions = questionnaire.questions.shuffle(random: randomizer).map { |q| MultipleChoices::SolvedQuestionPresenter.new(q, answers[q.id.to_s], randomizer) }
  end

  def points
    @questions.select { |x| x.correct }.count
  end

  def total_points
    @questions.size
  end
end
