module MultipleChoices
  class QuestionsController < ApplicationController
    before_action do
      check_feature(:multiple_choices)
    end

    def index
      authorize MultipleChoices::Question, :access?
      @questions = MultipleChoices::Question.all
    end

    def new
      authorize MultipleChoices::Question, :manage?
      @question = MultipleChoices::Question.new
      @labels = OpenStruct.new(title: "Nueva pregunta", button: "Guardar pregunta")

      # utilizar el código de contact data de MM para esto, con vuejs, agregar preguntas

      render :form
    end

    def create
      authorize MultipleChoices::Question, :manage?
      @question = MultipleChoices::Question.new(question_params)

      if @question.valid?
        @question.save
        redirect_to multiple_choices_questions_path
        flash[:info] = "Se creó correctamente la pregunta"
      else
        @labels = OpenStruct.new(title: "Nueva pregunta", button: "Guardar pregunta")
        render :form
      end
    end

    def edit
      authorize MultipleChoices::Question, :manage?
      @question = MultipleChoices::Question.find(params[:id])
      @labels = OpenStruct.new(title: "Editar pregunta", button: "Actualizar pregunta")
      render :form
    end

    def update
      authorize MultipleChoices::Question, :manage?
      @question = MultipleChoices::Question.find(params[:id])

      if @question.update_attributes(question_params)
        redirect_to multiple_choices_questions_path
        flash[:info] = "Se editó correctamente el pregunta"
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

    def practice
=begin
      @question = MultipleChoices::Question.find(params[:id])
      authorize @question, :access?
      @question = MultipleChoices::QuestionPresenter.new(@question)
=end
    end

    private
      def question_params
        params[:multiple_choices_question].permit(:wording)
      end
  end
end
