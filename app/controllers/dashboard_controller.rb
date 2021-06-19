class DashboardController < ApplicationController
  layout "application2"

  def index
    @post = policy(Post).manage? ? Post.new : nil

    @posts = Post.all


    @challenges = PeerReview::Challenge.published
    @questionnaires = MultipleChoices::Questionnaire.published
  end
end
