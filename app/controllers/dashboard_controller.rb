class DashboardController < ApplicationController
  layout "application2"

  def index
    @challenges = PeerReview::Challenge.published
  end
end
