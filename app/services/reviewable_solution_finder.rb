class ReviewableSolutionFinder
  def initialize(challenge, user)
    @challenge = challenge
    @user = user
  end


  def find_review
    # Specs:
    # 1. tiene que ser la tarea que estaba revisando, si hay alguna en progreso para este desafío
    # 2. si no, tiene que ser una nueva para la tarea menos revisada QUE NO HAYA REVISADO ANTERIORMENTE
    # 3. si no hay más, debe avisarle que no puede revisar más. No debería darle el botón siquiera

    started_reviews = @challenge.reviews.where(reviewer: @user, status: :draft)
    return started_reviews.first unless started_reviews.empty?

    reviewed_solutions = @challenge.reviews.where(reviewer: @user).map(&:solution)
    reviewable_solutions = @challenge.solutions.where.not(id: reviewed_solutions.map(&:id), author: @user)
    # BUG: que NO sea la solucion propia... ¬¬

    unless reviewable_solutions.empty?
      solution = reviewable_solutions.sample
      PeerReview::Review.create(solution: solution, reviewer: @user, status: :draft)
    else
      nil
    end
  end
end
