module MultipleChoices
  class QuestionnairesController < ApplicationController
    layout "application2", only: [:practice, :grade, :index, :last]

    include Publisher.new(MultipleChoices::Questionnaire, :multiple_choices_questionnaires)

    before_action do
      check_feature(:multiple_choices)
    end

    def index
      authorize MultipleChoices::Questionnaire, :access?
      if current_user.teacher?
        @questionnaires = MultipleChoices::Questionnaire.all
      else
        @questionnaires = MultipleChoices::Questionnaire.published
      end
    end

    def new
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.new
      @labels = OpenStruct.new(title: "Nuevo cuestionario", button: "Guardar cuestionario")
      render :form
    end

    def create
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.new(questionnaire_params)
      @questionnaire.published = false

      if @questionnaire.valid?
        @questionnaire.save
        redirect_to multiple_choices_questionnaires_path
        flash[:success] = "Se creó correctamente el cuestionario"
      else
        @labels = OpenStruct.new(title: "Nuevo cuestionario", button: "Guardar cuestionario")
        render :form
      end
    end

    def edit
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])
      @labels = OpenStruct.new(title: "Editar cuestionario", button: "Actualizar cuestionario")
      render :form
    end

    def update
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])

      if @questionnaire.update_attributes(questionnaire_params)
        redirect_to multiple_choices_questionnaires_path
        flash[:success] = "Se editó correctamente el cuestionario"
      else
        @labels = OpenStruct.new(title: "Editar cuestionario", button: "Actualizar cuestionario")
        render :form
      end
    end

    def destroy
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])
      @questionnaire.destroy

      redirect_to multiple_choices_questionnaires_path
      flash[:success] = "Se eliminó el cuestionario"
    end

    def toggle
      authorize MultipleChoices::Questionnaire, :manage?
      questionnaire = MultipleChoices::Questionnaire.find(params[:id])
      questionnaire.update_attributes(enabled: !questionnaire.enabled?)
      redirect_to multiple_choices_questionnaires_path
    end

    def overview
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])
      @solutions = @questionnaire.solutions
    end

    def practice
      @questionnaire = MultipleChoices::Questionnaire.includes(:questions, questions: :answers).find(params[:id])

      unless @questionnaire.enabled?
        flash[:info] = "Este cuestionario ya ha finalizado..."
        redirect_to(multiple_choices_questionnaires_path) && return
      end

      last_solution = @questionnaire.solutions.where(solver: current_user).order(:created_at).last
      if last_solution
        if last_solution.score == 100
          flash[:info] = "Ya no podés resolver este cuestionario... ¡Obtuviste calificación perfecta! ¡Buen trabajo!"
          redirect_to(multiple_choices_questionnaires_path) && return
        end
        if last_solution.created_at > (Time.current - 1.day)
          flash[:info] = "Debes esperar al menos un día para volver a intentarlo..."
          redirect_to(multiple_choices_questionnaires_path) && return
        end
      end

      authorize @questionnaire, :access?

      set_random_seed
      @questionnaire = MultipleChoices::PracticeQuestionnairePresenter.new(@questionnaire, Random.new(random_seed))
    end

    def grade
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])

      last_solution = @questionnaire.solutions.where(solver: current_user).order(:created_at).last
      if last_solution
        if last_solution.score == 100
          flash[:info] = "Ya no podés resolver este cuestionario... ¡Obtuviste calificación perfecta! ¡Buen trabajo!"
          redirect_to(multiple_choices_questionnaires_path) && return
        end
        if last_solution.created_at > (Time.current - 1.day)
          flash[:info] = "Debes esperar al menos un día para volver a intentarlo..."
          redirect_to(multiple_choices_questionnaires_path) && return
        end
      end

      authorize @questionnaire, :access?

      solution = MultipleChoices::Solution.create(solver: current_user, questionnaire: @questionnaire)
      answers = params[:question]
      @questionnaire.questions.visible.includes(:answers).each do |q|
        this_answer = answers[q.id.to_s][:answer]
        solution.responses << MultipleChoices::Response.create(question: q, multiple_choices_answer_id: this_answer, correct: q.correct_answer.id == this_answer.to_i)
      end
      solution.refresh_score!

      @questionnaire = MultipleChoices::SolvedQuestionnairePresenter.new(@questionnaire, Random.new(random_seed), solution)
    end

    def last
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])
      authorize @questionnaire, :access?

      @last_solution = @questionnaire.solutions.where(solver: current_user).order(:created_at).last
      unless @last_solution
        flash[:alert] = "Aún no resolviste este cuestionario"
        redirect_to(multiple_choices_questionnaires_path) && return
      end


      @questionnaire = MultipleChoices::SolvedQuestionnairePresenter.new(@questionnaire, Random.new(random_seed || 0), @last_solution)
    end

    private
      def questionnaire_params
        params[:multiple_choices_questionnaire].permit(:name,
                                                       questions_attributes: [:id, :wording, :hidden, :_destroy, :deleted_at,
                                                       answers_attributes: %i[id text explanation correct _destroy deleted_at]])
      end
  end
end
