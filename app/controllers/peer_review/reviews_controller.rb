module PeerReview
  class ReviewsController < ApplicationController
    layout "application2", only: [:new]

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
      # permisos? sólo comenta el que lo ve?
      review = PeerReview::Review.find(params[:message][:review_id])
      challenge = review.challenge
      message = Message.new(message_params)
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
      @review.rubrics = build_rubrics

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
      def build_rubrics
        return {} unless params[:rubrics]
        Hash[ params[:rubrics].to_unsafe_h.map { |x, y| [x, y.to_i] } ]
      end

      def wording_params
        params[:peer_review_review_items].to_s
      end

      def assessment_params
        params[:peer_review_review].permit(:teacher_assessment_description)
      end

      def solution_params
        params[:peer_review_review].permit(:wording)
      end

      def message_params
        params[:message].permit(:content, :peer_review_review_id)
      end

      def publishing?
        params[:status].to_sym == :final
      end
  end
end
