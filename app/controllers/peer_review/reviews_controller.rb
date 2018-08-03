module PeerReview
  class ReviewsController < ApplicationController
    def new
      authorize PeerReview::Challenge, :review?
      @challenge = PeerReview::Challenge.find(params[:challenge_id])

      @review = ::ReviewableSolutionFinder.new(@challenge, current_user).find_review

      if @review.nil?
        redirect_to peer_review_challenge_path(@challenge)
        flash[:info] = "No se puede revisar ninguna solución"
      end
    end

    def update
      authorize PeerReview::Challenge, :review? # TODO: probar que es la tarea que estaba revisando
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
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
