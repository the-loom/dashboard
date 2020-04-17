module PeerReview
  class SolutionsController < ApplicationController
    def show
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find(params[:id])
      @reviews = @challenge.reviews.where(reviewer: @solution.author)
      authorize @solution, :manage?
    end

    def review
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find(params[:id])
      @review = @solution.reviews.find_or_create_by(reviewer: current_user, status: :draft)
      render "peer_review/reviews/new"
    end

    def new
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      authorize @challenge, :solve?
      @solution = PeerReview::Solution.find_or_create_by(challenge: @challenge, author: current_user)
      authorize @solution, :solve?
    end

    def remove_attachment
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find_by(challenge: @challenge, author: current_user)
      authorize @solution, :solve?
      @solution.solution_attachment.purge

      render action: :new
    end

    def update
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find_by(challenge: @challenge, author: current_user)
      authorize @solution, :solve?
      @solution.update_attributes(solution_params)

      @solution.publish! if publishing?

      if @solution.valid?
        @solution.save
        redirect_to(peer_review_challenge_path(@challenge)) && (return)
        flash[:info] = "Se guardó correctamente la solución"
      else
        @solution.solution_attachment.purge if @solution.errors.include?(:solution_attachment)
        flash[:alert] = "Ha ocurrido un error con tu solución. " + @solution.errors.full_messages.join(", ")
        @solution.unpublish!
        # TEMP FIX
        redirect_to(peer_review_challenge_path(@challenge)) && (return)
      end
    end

    def unpublish
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find_by(challenge: @challenge, author: current_user)
      if @solution.author == current_user && @solution.unpublishable?
        @solution.unpublish!
        flash[:info] = "Se despublicó tu solución. Podés volver a trabajar en ella"
      else
        flash[:alert] = "Esta vez no ha podido despublicarse tu solución"
      end
      redirect_to peer_review_challenge_path(@challenge)
    end

    private
      def solution_params
        params[:peer_review_solution].permit(:wording, :solution_attachment)
      end

      def publishing?
        params[:status].to_sym == :final
      end
  end
end
