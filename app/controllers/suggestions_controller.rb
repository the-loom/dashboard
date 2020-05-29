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
    if current_user.admin?
      @suggestions = Suggestion.unscoped.discarded
    else
      @suggestions = Suggestion.discarded
    end
    render action: :index
  end

  def upvote
    authorize Suggestion, :use?
    suggestion = Suggestion.find(params[:id])
    suggestion.vote_up current_user
    redirect_to suggestions_path
    flash[:info] = "¡Gracias por tu voto!"
  end

  def downvote
    authorize Suggestion, :use?
    suggestion = Suggestion.find(params[:id])
    suggestion.vote_down current_user
    redirect_to suggestions_path
    flash[:info] = "¡Gracias por tu voto!"
  end

  def unvote
    authorize Suggestion, :use?
    suggestion = Suggestion.find(params[:id])
    suggestion.unvote_up current_user
    suggestion.unvote_down current_user
    redirect_to suggestions_path
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

  def restore
    authorize Suggestion, :manage?

    suggestion = Suggestion.find(params[:id])
    suggestion.undiscard

    redirect_to suggestions_path
  end

  private
    def suggestion_params
      params[:suggestion].permit(:title, :body, :suggestion_type)
    end
end
