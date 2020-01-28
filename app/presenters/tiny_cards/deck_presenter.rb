class TinyCards::DeckPresenter
  attr_reader :deck
  delegate :name, to: :deck

  def initialize(deck)
    @deck = deck
  end

  def to_json
    {
        name: @deck.name,
        cards: @deck.cards.map do |card|
          {
              # front_image: ActionController::Base.helpers.image_tag(card.front_image),
              # back_image: ActionController::Base.helpers.image_tag(card.back_image),
              front: card.front,
              back: card.back
          }
        end
    }.to_json
  end
end
