module PeerReview
  class ChallengesController < ApplicationController
    def index
      authorize PeerReview::Challenge, :index?
      @challenges = PeerReview::Challenge.all
    end

    def new
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.new
    end

    def create
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.new(challenge_params)

      if @challenge.valid?
        @challenge.save
        redirect_to peer_review_challenges_path
        flash[:info] = "Se creó correctamente el desafío"
      else
        render action: :new
      end
    end

    def show
      authorize PeerReview::Challenge, :index?
      @challenge = PeerReview::Challenge.find(params[:id])
      @solution = @challenge.solution_by(current_user) if @challenge.already_solved_by? current_user
    end

    private

      def challenge_params
        params[:peer_review_challenge].permit(:title, :instructions, :reviewer_instructions, :difficulty)
      end
  end
end
