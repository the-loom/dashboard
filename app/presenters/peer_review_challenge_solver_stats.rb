class PeerReviewChallengeSolverStats
  attr_reader :solver

  def initialize(challenge, solver)
    @challenge = challenge
    @solver = solver
  end

  def solution
    @sol ||= @challenge.solution_by(solver)
  end

  def reviews_made(status = :final)
    @challenge.reviews.where(reviewer: solver, status: status).count
  end

  def reviews_received(status = :final)
    solution.reviews.where(status: status).count
  end
end
