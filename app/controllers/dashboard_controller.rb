class DashboardController < ApplicationController
  layout "application2"

  def index
    @challenges = PeerReview::Challenge.published
    @questionnaires = MultipleChoices::Questionnaire.published
  end
end
