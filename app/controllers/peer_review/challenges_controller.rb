module PeerReview
  class ChallengesController < ApplicationController
    layout "application2", only: [:show]

    include Publisher.new(PeerReview::Challenge, :peer_review_challenges)

    MAX_EXTRA_REVIEWS = 3

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

    def flow
      @challenge = PeerReview::Challenge.find_by(id: params[:id])

      unless @challenge
        flash[:alert] = "No pudimos encontrar el desafío que buscás... ¿es de este curso?"
        redirect_to(peer_review_challenges_path) && return
      end

      authorize @challenge, :manage?
      @flow_overview = PeerReview::FlowOverviewPresenter.new(PeerReview::Review.includes(:reviewer, :solution, solution: :author).where(peer_review_solutions: { peer_review_challenge_id: @challenge.id }))
      render :flow_overview
    end

    def overview
      authorize PeerReview::Challenge, :manage?
      @challenge = PeerReview::Challenge.find(params[:id])
      @solvers = @challenge.team_challenge? ? @challenge.solvers : Course.current.users
      @overview = PeerReview::OverviewPresenter.new(@challenge)
    end

    def meta_overview
      authorize PeerReview::Challenge, :manage?
      @challenges = PeerReview::Challenge.where(published: :true).order(title: :asc)
      @students = Course.current.memberships.includes(:user).student.collect(&:user)
      @overview = PeerReviewChallengesStats.new(@students, @challenges)
    end

    def flow_overview
      authorize PeerReview::Challenge, :manage?
      @flow_overview = PeerReview::FlowOverviewPresenter.new(PeerReview::Review.includes(:reviewer, :solution, solution: :author))
    end

    def bulk_download
      # TODO: use case
      @challenge = PeerReview::Challenge.find(params[:id])
      temp_file = Tempfile.new(%w(export zip))
      layout = "../peer_review/challenges/export/layout"

      begin
        Zip::OutputStream.open(temp_file) { |zos| }

        Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
          instructions_file = Tempfile.new(%w(instructions html))
          instructions_file.write(render_to_string "peer_review/challenges/export/instructions", layout: layout)

          instructions_file.close
          zipfile.add("consigna.html", instructions_file.path)

          temp_files = []
          @challenge.solutions.each do |solution|
            temp_files << Tempfile.new(%w(solution html))

            @solution = solution
            temp_files.last.write(render_to_string "peer_review/challenges/export/solution", layout: layout)
            temp_files.last.close

            folder_name = "#{solution.author.last_name.downcase}-#{solution.author.first_name.downcase}-#{solution.author.uuid}"
            zipfile.add("soluciones/#{folder_name}/solucion.html", temp_files.last.path)

            solution.reviews.each_with_index do |review, index|
              temp_files << Tempfile.new(%w(review html))
              @review = review
              temp_files.last.write(render_to_string "peer_review/challenges/export/review", layout: layout)
              temp_files.last.close

              zipfile.add("soluciones/#{folder_name}/revision-#{(index + 1).to_s.rjust(2, "0")}.html", temp_files.last.path)
            end

            document = solution.solution_attachment
            if document.attached?
              temp_files << Tempfile.new("attachment")
              temp_files.last.binmode
              temp_files.last.write(document.attachment.download)
              temp_files.last.close

              zipfile.add("soluciones/#{folder_name}/#{document.filename}", temp_files.last.path)
            end
          end
        end

        zip_data = File.read(temp_file.path)
        filename = "#{@challenge.title}.zip"
        send_data(zip_data, type: "application/zip", disposition: "attachment", filename: filename)
      ensure
        temp_file.close
        temp_file.unlink
      end
    end

    def award
      # TODO: use case
      authorize PeerReview::Challenge, :manage?
      challenge = PeerReview::Challenge.find(params[:id])

      if challenge.awarded
        flash[:alert] = "No puede volver a premiarse el desafío"
        redirect_to(peer_review_challenges_path) && return
      end

      ActiveRecord::Base.transaction do
        solve = "Resolver '#{challenge.title}'"
        solve_event = Event.create(name: solve, description: solve, points: 8, min_points: 8, max_points: 8)

        review = "Revisar '#{challenge.title}'"
        review_event = Event.create(name: review, description: review, points: 6, min_points: 6, max_points: 12)

        extra_review = "Revisión extra sobre '#{challenge.title}'"
        extra_review_event = Event.create(name: extra_review, description: extra_review, points: 4, min_points: 0, max_points: 0)


        challenge.solutions.final.each { |s|
          next unless s.author
          s.author.register(solve_event)
        }

        reviews_by_reviewer = challenge.reviews.group_by { |r| r.reviewer }
        reviews_by_reviewer.each { |reviewer, reviews|
          next unless reviewer
          total_reviews = reviews.size
          base_reviews = [total_reviews, challenge.expected_reviews].min
          extra_reviews = [total_reviews - base_reviews, MAX_EXTRA_REVIEWS].min

          reviewer.register(review_event, base_reviews)

          reviewer.register(extra_review_event, extra_reviews)
        }
        challenge.update(awarded: true)
      end

      redirect_to peer_review_challenges_path
      flash[:info] = "Se premió correctamente el desafío"
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
      @challenge = PeerReview::Challenge.find_by(id: params[:id])

      unless @challenge
        flash[:alert] = "No pudimos encontrar el desafío que buscás... ¿es de este curso?"
        redirect_to(peer_review_challenges_path) && return
      end

      authorize @challenge, :show?
      @solution = ::SolutionFinder.new(@challenge, current_user).find_solution
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

      challenge.purge!

      flash[:info] = "Se purgó correctamente el desafío"
      redirect_to peer_review_challenges_path
    end

    private
      def challenge_params
        params[:peer_review_challenge].permit(:title, :instructions, :reviewer_instructions,
                                              :difficulty, :challenge_mode, :due_date,
                                              :allows_attachment, :expected_reviews, :team_challenge,
                                              :solution_type, :language, :allows_quick_reviews, :optional)
      end
  end
end
