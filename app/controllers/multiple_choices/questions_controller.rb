module MultipleChoices
  class QuestionsController < ApplicationController
    before_action do
      check_feature(:multiple_choices)
    end

    def new
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.find(params[:questionnaire_id])
      @question = @questionnaire.questions.new
      @question.answers.build
      @question.answers.build
      @labels = OpenStruct.new(title: "Nueva pregunta", button: "Guardar pregunta")
      render :form
    end

    def create
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.find(params[:questionnaire_id])
      @question = @questionnaire.questions.new(question_params)

      if @question.valid?
        @question.save
        redirect_to multiple_choices_questionnaire_path(@questionnaire)
        flash[:info] = "Se creó correctamente la pregunta"
      else
        @labels = OpenStruct.new(title: "Nueva pregunta", button: "Guardar pregunta")
        render :form
      end
    end

    def edit
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.find(params[:questionnaire_id])
      @question = @questionnaire.questions.find(params[:id])
      @labels = OpenStruct.new(title: "Editar pregunta", button: "Actualizar pregunta")
      render :form
    end

    def update
      authorize MultipleChoices::Questionnaire, :manage?
      @questionnaire = MultipleChoices::Questionnaire.find(params[:questionnaire_id])
      @question = @questionnaire.questions.find(params[:id])

      if @question.update_attributes(question_params)
        redirect_to multiple_choices_questionnaire_path(@questionnaire)
        flash[:info] = "Se editó correctamente la pregunta"
      else
        @labels = OpenStruct.new(title: "Editar pregunta", button: "Actualizar pregunta")
        render :form
      end
    end

    def destroy
      authorize MultipleChoices::Question, :manage?
      @question = MultipleChoices::Question.find(params[:id])
      @question.destroy

      redirect_to multiple_choices_questions_path
      flash[:info] = "Se eliminó la pregunta"
    end

    private
      def question_params
        params[:multiple_choices_question].permit(:wording,
                                                  answers_attributes: %i[id text explanation correct _destroy deleted_at])
      end
  end
end
