module PeerReview
  class ReviewsController < ApplicationController
    layout "application5", only: [:new]

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

    def add_message
      review = PeerReview::Review.find(params[:id])
      authorize review, :message?

      challenge = review.challenge
      message = review.messages.new(message_params)
      message.user = current_user

      if message.valid?
        message.save
        message.notify!
        redirect_to peer_review_challenge_path(challenge)
        flash[:success] = "Se creó correctamente el comentario"
      else
        redirect_to peer_review_challenge_path(challenge)
        flash[:error] = "No hemos podido publicar tu comentario"
      end
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
      @review.rubrics = build_rubrics

      if @review.valid?
        @review.save
        flash[:success] = "Se guardó correctamente la revisión"
        if current_user.teacher?
          redirect_to overview_peer_review_challenge_path(@challenge)
        else
          redirect_to dashboard_index_path
        end
      else
        render action: :new
      end
    end

    private
      def build_rubrics
        return {} unless params[:rubrics]
        Hash[ params[:rubrics].to_unsafe_h.map { |x, y| [x, y.to_i] } ]
      end

      def wording_params
        params[:peer_review_review_items].to_s
      end

      def solution_params
        params[:peer_review_review].permit(:wording)
      end

      def message_params
        params[:message].permit(:content)
      end

      def publishing?
        params[:status].to_sym == :final
      end
  end
end
