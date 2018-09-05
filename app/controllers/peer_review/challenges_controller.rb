module PeerReview
  class ChallengesController < ApplicationController
    def index
      authorize PeerReview::Challenge, :index?

      #TODO(delucas): pundit?
      if current_user.teacher?
        @challenges = PeerReview::Challenge.all
      else
        @challenges = PeerReview::Challenge.enabled
      end
    end

    def overview
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.find(params[:id])
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
      @challenge = PeerReview::Challenge.find(params[:id])
      authorize @challenge, :show?
      @solution = @challenge.solution_by(current_user) if @challenge.already_solved_by? current_user
    end

    def toggle
      authorize PeerReview::Challenge, :manage?
      challenge = PeerReview::Challenge.find(params[:id])
      challenge.update_attributes(enabled: !challenge.enabled?)
      redirect_to peer_review_challenges_path
    end

    private

      def challenge_params
        params[:peer_review_challenge].permit(:title, :instructions, :reviewer_instructions, :difficulty)
      end
  end
end
