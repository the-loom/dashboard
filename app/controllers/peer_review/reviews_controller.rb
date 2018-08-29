module PeerReview
  class ReviewsController < ApplicationController
    def show
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @review = PeerReview::Review.find(params[:id])
      @solution = @review.solution
      authorize @review, :manage?
    end

    def new
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      authorize @challenge, :review?

      @review = ::ReviewableSolutionFinder.new(@challenge, current_user).find_review

      if @review.nil?
        redirect_to peer_review_challenge_path(@challenge)
        flash[:info] = "No se puede revisar ninguna solución"
      end
    end

    def update
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      authorize @challenge, :review?
      @review = PeerReview::Review.find(params[:id])
      @review.publish! if publishing?
      @review.update_attributes(solution_params)

      if @review.valid?
        @review.save
        redirect_to peer_review_challenge_path(@challenge)
        flash[:info] = "Se guardó correctamente la revisión"
      else
        render action: :new
      end
    end

    private

      def solution_params
        params[:peer_review_review].permit(:wording)
      end

      def publishing?
        params[:status].to_sym == :final
      end
  end
end
