class MultipleChoices::SolvedQuestionnairePresenter
  attr_reader :questionnaire, :questions

  delegate :name, to: :questionnaire

  def initialize(questionnaire, answers)
    @questionnaire = questionnaire
    @questions = questionnaire.questions.includes(:answers).map { |q| MultipleChoices::SolvedQuestionPresenter.new(q, answers[q.id.to_s]) }
  end

  def points
    @questions.select { |x| x.correct }.count
  end

  def total_points
    @questions.size
  end
end
