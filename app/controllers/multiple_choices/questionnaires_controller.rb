module MultipleChoices
  class QuestionnairesController < ApplicationController
    include Publisher.new(MultipleChoices::Questionnaire, :multiple_choices_questionnaires)

    before_action do
      check_feature(:multiple_choices)
    end

    def index
      authorize MultipleChoices::Questionnaire, :access?
      @questionnaires = MultipleChoices::Questionnaire.all
    end

    def show
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])
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

      if @questionnaire.valid?
        @questionnaire.save
        redirect_to multiple_choices_questionnaires_path
        flash[:info] = "Se creó correctamente el cuestionario"
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
        flash[:info] = "Se editó correctamente el cuestionario"
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
      flash[:info] = "Se eliminó el cuestionario"
    end

    def practice
      # randomize all!
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])
      authorize @questionnaire, :access?
    end

    def grade
      # honor randomization!
      @questionnaire = MultipleChoices::Questionnaire.find(params[:id])
      authorize @questionnaire, :access?

      # TODO: use case

      solution = MultipleChoices::Solution.create(solver: current_user, questionnaire: @questionnaire)
      answers = params[:question]
      @questionnaire.questions.includes(:answers).each do |q|
        this_answer = answers[q.id.to_s][:answer]
        solution.responses << MultipleChoices::Response.create(question: q, multiple_choices_answer_id: this_answer, correct: q.correct_answer.id == this_answer.to_i)
      end
      solution.refresh_score!

      @questionnaire = MultipleChoices::SolvedQuestionnairePresenter.new(@questionnaire, params[:question])
    end

    private
      def questionnaire_params
        params[:multiple_choices_questionnaire].permit(:name)
      end
  end
end
