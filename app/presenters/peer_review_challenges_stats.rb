class PeerReviewChallengesStats
  def initialize(student)
    @student = student
  end

  def resolved_at(challenge)
    challenge.solution_by(@student) != nil
  end
end
