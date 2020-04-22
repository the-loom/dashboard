module PeerReview
  class ChallengesController < ApplicationController
    include Publisher.new(PeerReview::Challenge, :peer_review_challenges)

    before_action do
      check_feature(:peer_review_challenges)
    end

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
      @overview = PeerReview::OverviewPresenter.new(@challenge)
    end

    def new
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.new
      @labels = OpenStruct.new(title: "Nuevo desafío", button: "Guardar desafío")
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
        @labels = OpenStruct.new(title: "Nuevo desafío", button: "Guardar desafío")
        render :form
      end
    end

    def edit
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.find(params[:id])
      @labels = OpenStruct.new(title: "Editar desafío", button: "Actualizar desafío")
      render :form
    end

    def duplicate
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.find(params[:id]).dup
      @labels = OpenStruct.new(title: "Nuevo desafío", button: "Guardar desafío")
      render :form
    end

    def update
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.find(params[:id])

      if @challenge.update_attributes(challenge_params)
        redirect_to peer_review_challenges_path
        flash[:info] = "Se editó correctamente el desafío"
      else
        @labels = OpenStruct.new(title: "Editar desafío", button: "Actualizar desafío")
        render :form
      end
    end

    def show
      @challenge = PeerReview::Challenge.find(params[:id])
      authorize @challenge, :show?
      @solution = @challenge.solution_by(current_user)
    end

    def toggle
      authorize PeerReview::Challenge, :manage?
      challenge = PeerReview::Challenge.find(params[:id])
      challenge.update_attributes(enabled: !challenge.enabled?)
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
        params[:peer_review_challenge].permit(:title, :instructions, :reviewer_instructions,
                                              :difficulty, :challenge_mode, :due_date, :allows_attachment,
                                              :solution_type, :language)
      end
  end
end
