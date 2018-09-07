class PeerReviewChallengeSolverStats
  attr_reader :solver

  def initialize(challenge, solver)
    @challenge = challenge
    @solver = solver
  end

  def solution
    @challenge.solution_by(solver)
  end

  def reviews_made
    @challenge.reviews.where(reviewer: solver).count
  end

  def reviews_received
    solution.reviews.count
  end

end
