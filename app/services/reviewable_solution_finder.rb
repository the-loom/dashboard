class ReviewableSolutionFinder
  def initialize(challenge, user)
    @challenge = challenge
    @user = user
  end

  def find_review
    started_reviews = @challenge.reviews.where(reviewer: @user, status: :draft)
    return started_reviews.first unless started_reviews.empty?

    reviewed_solutions = @challenge.reviews.where(reviewer: @user).map(&:solution)
    reviewable_solutions = @challenge.solutions
                                     .where(status: :final)
                                     .where.not(id: reviewed_solutions.map(&:id))
                                     .where.not(author: @user)

    unless reviewable_solutions.empty?
      solution = reviewable_solutions.sort_by { |sol| sol.reviews.count }.first
      PeerReview::Review.create(solution: solution, reviewer: @user, status: :draft)
    else
      nil
    end
  end
end
