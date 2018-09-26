module PeerReview
  class ChallengesController < ApplicationController
    def index
      authorize PeerReview::Challenge, :index?
      if current_user.teacher?
        @challenges = PeerReview::Challenge.all
      else
        @challenges = PeerReview::Challenge.published
      end
    end

    def overview
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.find(params[:id])
    end

    def new
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.new
      @labels = OpenStruct.new(title: "Nuevo desafio", button: "Guardar desaf\u00EDo")
      render :form
    end

    def create
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.new(challenge_params)

      if @challenge.valid?
        @challenge.save
        redirect_to peer_review_challenges_path
        flash[:info] = "Se creó correctamente el desafío"
      else
        render action: :new
      end
    end

    def edit
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.find(params[:id])
      @labels = OpenStruct.new(title: "Editar desaf\u00EDo", button: "Actualizar desaf\u00EDo")
      render :form
    end

    def update
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.find(params[:id])

      if @challenge.update_attributes(challenge_params)
        redirect_to peer_review_challenges_path
        flash[:info] = "Se editó correctamente el desafío"
      else
        render action: :edit
      end
    end

    def show
      @challenge = PeerReview::Challenge.find(params[:id])
      authorize @challenge, :show?
      @solution = @challenge.solution_by(current_user) if @challenge.already_solved_by? current_user
    end

    def toggle
      authorize PeerReview::Challenge, :manage?
      challenge = PeerReview::Challenge.find(params[:id])
      challenge.update_attributes(enabled: !challenge.enabled?)
      redirect_to peer_review_challenges_path
    end

    def publish
      authorize PeerReview::Challenge, :manage?
      challenge = PeerReview::Challenge.find(params[:id])

      if params[:mode] == "publish"
        challenge.publish!
      else
        challenge.unpublish!
      end

      redirect_to peer_review_challenges_path
    end

    def purge
      authorize PeerReview::Challenge, :purge?
      challenge = PeerReview::Challenge.find(params[:id])

      challenge.solutions.where(status: :draft).delete_all
      challenge.reviews.where(status: :draft).delete_all

      flash[:info] = "Se purgó correctamente el desafío"
      redirect_to peer_review_challenges_path
    end

    private

      def challenge_params
        params[:peer_review_challenge].permit(:title, :instructions, :reviewer_instructions, :difficulty)
      end
  end
end
