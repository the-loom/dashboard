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

      @quick_reviews = QuickReviewGenerator.generate(@challenge, @review) if current_user.teacher? && @challenge.allows_quick_reviews?

      render "peer_review/reviews/new"
    end

    def new
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      authorize @challenge, :solve?
      @solution = ::SolutionFinder.new(@challenge, current_user).find_solution
      @solution.save
      authorize @solution, :solve?
    end

    def remove_attachment
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = PeerReview::Solution.find_by(challenge: @challenge, author: current_user)
      unless @challenge && @solution
        redirect_to(peer_review_challenge_path(@challenge)) && (return)
      end

      authorize @solution, :solve?
      @solution.solution_attachment.purge

      render action: :new
    end

    def update
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = ::SolutionFinder.new(@challenge, current_user).find_solution
      authorize @solution, :solve?
      @solution.update(solution_params)
      @solution.update(author: current_user) # team challenges, steal authorship

      if @solution.valid?
        @solution.save
        flash[:success] = "Se guardó correctamente la solución"
      else
        @solution.solution_attachment.purge if @solution.errors.include?(:solution_attachment)
        flash[:alert] = "Ha ocurrido un error con tu solución. " + @solution.errors.full_messages.join(", ")
      end
      redirect_to(peer_review_challenge_path(@challenge)) && (return)
    end

    def pick
      @solution = PeerReview::Solution.find(params[:id])
      authorize @solution, :manage?

      @solution.picked = true
      if @solution.save
        flash[:success] = "Se ha elegido esta solución como ejemplo para los estudiantes"
      else
        flash[:alert] = @solution.errors.full_messages
      end
      redirect_to peer_review_challenge_solution_path(@solution.challenge, @solution)
    end

    def unpick
      @solution = PeerReview::Solution.find(params[:id])
      authorize @solution, :manage?

      @solution.picked = false
      if @solution.save
        flash[:success] = "Se ha dejado de elegir esta solución como ejemplo"
      else
        flash[:alert] = @solution.errors.full_messages
      end
      redirect_to peer_review_challenge_solution_path(@solution.challenge, @solution)
    end

    # use automatic publishable?
    def publish
      @challenge = PeerReview::Challenge.find(params[:challenge_id])
      @solution = ::SolutionFinder.new(@challenge, current_user).find_solution
      authorize @solution, :solve?
      @solution.publish!

      if @solution.valid?
        flash[:success] = "Se publicó correctamente la solución"
      else
        flash[:alert] = "Ha ocurrido un error con tu solución. " + @solution.errors.full_messages.join(", ")
        @solution.unpublish!
      end
      redirect_to(peer_review_challenge_path(@challenge)) && (return)
    end

    # use automatic publishable?
    def unpublish
      @challenge = PeerReview::Challenge.find(params[:challenge_id])

      @solution = PeerReview::Solution.find(params[:id])
      if current_user.teacher?
      else
        @solution = PeerReview::Solution.find_by(challenge: @challenge, author: current_user)
      end

      if policy(@solution).unpublish?
        @solution.unpublish!
        flash[:success] = "Se despublicó tu solución. Podés volver a trabajar en ella"
      else
        flash[:alert] = "Esta vez no ha podido despublicarse tu solución"
      end

      if current_user.teacher?
        redirect_to overview_peer_review_challenge_path(@challenge)
      else
        redirect_to peer_review_challenge_path(@challenge)
      end
    end

    private
      def solution_params
        params[:peer_review_solution].permit(:wording, :solution_attachment)
      end
  end
end
