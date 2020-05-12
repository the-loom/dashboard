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
      @solvers = @challenge.team_challenge? ? @challenge.solvers : Course.current.users
      @overview = PeerReview::OverviewPresenter.new(@challenge)
    end

    def bulk_download
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
                                              :solution_type, :language, :allows_quick_reviews)
      end
  end
end
