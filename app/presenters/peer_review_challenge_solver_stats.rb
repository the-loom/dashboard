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
    return 0 unless @sol
    solution.reviews.where(status: status).count
  end

  def reviewed_by_teacher?
    solution.reviews.final.find { |r| r.reviewer.teacher? } != nil
  end

  def reviewed_by_teachers
    solution.reviews.final.select { |r| r.reviewer.teacher? }.map(&:reviewer).map(&:short_name).join(", ")
  end
end
