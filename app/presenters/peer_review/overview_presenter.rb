class PeerReview::OverviewPresenter
  attr_reader :registers

  def initialize(challenge)
    solutions = challenge.solutions.final.size
    reviews = challenge.reviews.final.size
    @registers = [
        OpenStruct.new(name: "Soluciones finalizadas", value: solutions),
        OpenStruct.new(name: "Revisiones finalizadas", value: reviews),
        OpenStruct.new(name: "Revisiones por ejercicio", value: solutions > 0 ? (reviews.to_f / solutions).round(2) : 0),
        OpenStruct.new(name: "Revisiones potenciales", value: solutions * (solutions - 1))
    ]
  end
end
