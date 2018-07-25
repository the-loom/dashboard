module PeerReview
  class SolutionsController < ApplicationController

    def new
      authorize PeerReview::Challenge, :solve?
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find_or_create_by(challenge: @challenge, author: current_user, status: :draft)
    end

    def update
      authorize PeerReview::Challenge, :solve?
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find_by(challenge: @challenge, author: current_user)
      @solution.update_attributes(solution_params)

      if @solution.valid?
        @solution.save
        redirect_to peer_review_challenge_path(@challenge)
        flash[:notice] = "Se guardó correctamente la solución"
      else
        render action: :new
      end
    end

    private

    def solution_params
      params[:peer_review_solution].permit(:wording)
    end

  end
end
