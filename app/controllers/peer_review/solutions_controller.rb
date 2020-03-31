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
      @review = @solution.reviews.create(reviewer: current_user, status: :draft)
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
      @solution.publish! if publishing?
      @solution.update_attributes(solution_params)

      if @solution.valid?
        @solution.save
        redirect_to peer_review_challenge_path(@challenge)
        flash[:info] = "Se guardó correctamente la solución"
      else
        @solution.solution_attachment.purge
        render action: :new
      end
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
