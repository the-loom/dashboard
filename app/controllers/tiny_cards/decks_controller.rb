module TinyCards
  class DecksController < ApplicationController

    include Publisher.new(TinyCards::Deck, :tiny_cards_decks)

    before_action do
      check_feature(:tiny_cards)
    end

    def index
      authorize TinyCards::Deck, :access?
      @decks = Course.current.decks
    end

    def new
      authorize TinyCards::Deck, :manage?
      @deck = TinyCards::Deck.new
      @labels = OpenStruct.new(title: "Nuevo mazo", button: "Guardar mazo")
      render :form
    end

    def create
      authorize TinyCards::Deck, :manage?
      @deck = TinyCards::Deck.new(deck_params)

      if @deck.valid?
        # Teachers always create for current course
        # Admins can share across courses
        @deck.courses << Course.current
        @deck.save
        redirect_to tiny_cards_decks_path
        flash[:info] = "Se creó correctamente el mazo"
      else
        @labels = OpenStruct.new(title: "Nuevo mazo", button: "Guardar mazo")
        render :form
      end
    end

    def edit
      authorize TinyCards::Deck, :manage?
      @deck = TinyCards::Deck.find(params[:id])
      @labels = OpenStruct.new(title: "Editar mazo", button: "Actualizar mazo")
      render :form
    end

    def update
      authorize TinyCards::Deck, :manage?
      @deck = TinyCards::Deck.find(params[:id])

      if @deck.update_attributes(deck_params)
        redirect_to tiny_cards_decks_path
        flash[:info] = "Se editó correctamente el mazo"
      else
        @labels = OpenStruct.new(title: "Editar mazo", button: "Actualizar mazo")
        render :form
      end
    end

    def destroy
      authorize TinyCards::Deck, :manage?
      @deck = TinyCards::Deck.find(params[:id])
      @deck.destroy

      redirect_to tiny_cards_decks_path
      flash[:info] = "Se eliminó el mazo"
    end

    def show
      @deck = TinyCards::Deck.find(params[:id])
      authorize @deck, :manage?
    end

    def practice
      @deck = TinyCards::Deck.find(params[:id])
      authorize @deck, :access?
      @deck = TinyCards::DeckPresenter.new(@deck)
    end

    private
      def deck_params
        params[:tiny_cards_deck].permit(:name, course_ids: [])
      end
  end
end
