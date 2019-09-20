class DashboardController < ApplicationController
  def index
    @peer_review_challenges = PeerReview::Challenge.published.enabled - current_user.peer_review_solutions.map { |x| x.challenge }
  end
end
