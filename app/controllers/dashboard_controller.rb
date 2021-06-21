class DashboardController < ApplicationController
  layout "application2"

  def index
    @exercises = Exercise.published
    @challenges = PeerReview::Challenge.published
    @questionnaires = MultipleChoices::Questionnaire.published
  end
end
