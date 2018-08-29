module PeerReview
  class SolutionsController < ApplicationController
    def show
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find(params[:id])
      authorize @solution, :manage?
    end

    def new
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find_or_create_by(challenge: @challenge, author: current_user)
      authorize @solution, :solve?
    end

    def update
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find_by(challenge: @challenge, author: current_user)
      authorize @solution, :solve?
      @solution.publish! if publishing?
      @solution.update_attributes(solution_params)

      if @solution.valid?
        @solution.save
        redirect_to peer_review_challenge_path(@challenge)
        flash[:info] = "Se guardó correctamente la solución"
      else
        render action: :new
      end
    end

    private

      def solution_params
        params[:peer_review_solution].permit(:wording)
      end

      def publishing?
        params[:status].to_sym == :final
      end
  end
end
