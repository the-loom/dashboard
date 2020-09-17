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

  def messages_on_received_reviews
    solution.reviews.map { |r| r.messages.count }.sum
  end

  def reviewed_by_teacher?
    _teachers_who_reviewed.count > 0
  end

  def teachers_who_reviewed
    _teachers_who_reviewed.map(&:reviewer).map(&:short_name).join(", ")
  end

  private
    def _teachers_who_reviewed
      @tr ||= solution.reviews.final.includes(:reviewer).select { |r| r.reviewer.teacher? }
    end
end
