class DashboardController < ApplicationController
  def index
    @challenges = PeerReview::Challenge.published
  end
end
