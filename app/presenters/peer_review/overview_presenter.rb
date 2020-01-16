class PeerReview::OverviewPresenter
  attr_reader :registers

  def initialize(challenge)
    @registers = [
        OpenStruct.new(name: "Soluciones", value: challenge.solutions.size),
        OpenStruct.new(name: "Revisiones", value: challenge.reviews.size),
        OpenStruct.new(name: "Revisiones por ejercicio", value: challenge.solutions.size > 0 ? (challenge.reviews.size.to_f / challenge.solutions.size).round(2) : 0),
        OpenStruct.new(name: "Revisiones potenciales", value: challenge.solutions.size * (challenge.solutions.size - 1))
    ]
  end
end
