class SuggestionsController < ApplicationController
  def index
    authorize Suggestion, :use?
    if current_user.admin?
      @suggestions = Suggestion.unscoped.kept
    else
      @suggestions = Suggestion.kept
    end
  end

  def dismissed
    authorize Suggestion, :manage?
    @suggestions = Suggestion.unscoped.discarded
    render action: :index
  end

  def new
    authorize Suggestion, :use?
    @suggestion = Suggestion.new
    @labels = OpenStruct.new(title: "Nueva sugerencia", button: "Guardar sugerencia")
    render :form
  end

  def create
    authorize Suggestion, :use?
    @suggestion = Suggestion.new(suggestion_params)
    @suggestion.author = current_user

    if @suggestion.valid?
      @suggestion.save
      redirect_to suggestions_path
      flash[:info] = "Se creo correctamente el sugerencia"
    else
      @labels = OpenStruct.new(title: "Nueva sugerencia", button: "Guardar sugerencia")
      render :form
    end
  end

  def destroy
    authorize Suggestion, :manage?

    suggestion = Suggestion.find(params[:id])
    suggestion.discard

    redirect_to suggestions_path
  end

  private
    def suggestion_params
      params[:suggestion].permit(:title, :body, :suggestion_type)
    end
end
