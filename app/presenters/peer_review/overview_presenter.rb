class PeerReview::OverviewPresenter
  attr_reader :registers

  def initialize(challenge)
    solutions = challenge.solutions.final.size
    reviews = challenge.reviews.final.size
    expected_reviews = challenge.teacher_reviews_only? ? solutions : solutions * challenge.expected_reviews
    @registers = [
        OpenStruct.new(name: "Soluciones finalizadas", value: solutions),
        OpenStruct.new(name: "Revisiones finalizadas", value: reviews),
        OpenStruct.new(name: "Revisiones por ejercicio", value: solutions > 0 ? (reviews.to_f / solutions).round(2) : 0),
        OpenStruct.new(name: "Revisiones esperadas", value: expected_reviews)
    ]
  end
end
