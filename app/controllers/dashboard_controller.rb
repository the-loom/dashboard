class DashboardController < ApplicationController
  def index
    @post = policy(Post).manage? ? Post.new : nil
    @posts = Post.all

    @exercises = Exercise.published
    @challenges = PeerReview::Challenge.published.order(due_date: :asc)
    @questionnaires = MultipleChoices::Questionnaire.published
  end
end
