module TinyCards
  class CardsController < ApplicationController
    before_action do
      check_feature(:tiny_cards)
    end

    def index
      authorize TinyCards::Card, :access?
      @cards = Course.current.cards
    end

    def new
      authorize TinyCards::Card, :manage?
      @deck = TinyCards::Deck.find(params[:deck_id])
      @card = @deck.cards.new
      @labels = OpenStruct.new(title: "Nueva carta", button: "Guardar carta")
      render :form
    end

    def create
      authorize TinyCards::Card, :manage?
      @deck = TinyCards::Deck.find(params[:deck_id])
      @card = @deck.cards.new(card_params)
      @card.author = current_user

      if @card.valid?
        @card.save
        redirect_to tiny_cards_deck_path(@deck)
        flash[:success] = "Se creó correctamente la carta"
      else
        @labels = OpenStruct.new(title: "Nueva carta", button: "Guardar carta")
        render :form
      end
    end

    def edit
      authorize TinyCards::Card, :manage?
      @deck = TinyCards::Deck.find(params[:deck_id])
      @card = @deck.cards.find(params[:id])
      @labels = OpenStruct.new(title: "Editar carta", button: "Actualizar carta")
      render :form
    end

    def update
      authorize TinyCards::Card, :manage?
      @card = TinyCards::Card.find(params[:id])

      if @card.update_attributes(card_params)
        redirect_to tiny_cards_deck_path(@card.deck)
        flash[:success] = "Se editó correctamente la carta"
      else
        @deck = TinyCards::Deck.find(@card.deck.id)
        @labels = OpenStruct.new(title: "Editar carta", button: "Actualizar carta")
        render :form
      end
    end

    def destroy
      authorize TinyCards::Card, :manage?
      @card = TinyCards::Card.find(params[:id])
      @card.destroy

      redirect_to tiny_cards_deck_path(@card.deck)
      flash[:success] = "Se eliminó la carta"
    end

    private
      def card_params
        params[:tiny_cards_card].permit(:front, :back, :front_image, :back_image)
      end
  end
end
