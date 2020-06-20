module PeerReview
  class ReviewsController < ApplicationController
    def new
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      authorize @challenge, :review?

      @review = ::ReviewableSolutionFinder.new(@challenge, current_user).find_review


      if @review.nil?
        flash[:info] = "No se puede revisar ninguna solución aún. Volvé en unos días."
        redirect_to(peer_review_challenge_path(@challenge)) && return
      end

      @quick_reviews = QuickReviewGenerator.generate(@challenge, @review) if current_user.teacher? && @challenge.allows_quick_reviews?
    end

    def assess
      challenge = PeerReview::Challenge.find(params[:challenge_id])
      review = challenge.reviews.find(params[:id])
      authorize review, :assess?

      review.teacher_assessment = params[:teacher_assessment].to_sym
      review.assessor = current_user
      review.update_attributes(assessment_params)
      review.save

      redirect_to peer_review_challenge_solution_path(review.challenge, params[:peer_review_review][:current_solution_id])
    end

    def update
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      authorize @challenge, :review?
      @review = @challenge.reviews.find(params[:id])
      if publishing?
        @review.publish!
        @review.notify!
      end
      if @challenge.allows_quick_reviews?
        @review.wording = wording_params
      else
        @review.update_attributes(solution_params)
      end

      if @review.valid?
        @review.save
        flash[:success] = "Se guardó correctamente la revisión"
        if current_user.teacher?
          redirect_to overview_peer_review_challenge_path(@challenge)
        else
          redirect_to peer_review_challenge_path(@challenge)
        end
      else
        render action: :new
      end
    end

    private
      def wording_params
        params[:peer_review_review_items].to_s
      end

      def assessment_params
        params[:peer_review_review].permit(:teacher_assessment_description)
      end

      def solution_params
        params[:peer_review_review].permit(:wording)
      end

      def publishing?
        params[:status].to_sym == :final
      end
  end
end
