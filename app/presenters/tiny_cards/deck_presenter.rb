class TinyCards::DeckPresenter
  attr_reader :deck
  delegate :name, to: :deck

  include Rails.application.routes.url_helpers

  def initialize(deck)
    @deck = deck
  end

  def image_url(img)
    if img&.attachment
      if Rails.env.development?
        re = Rails.application.routes.url_helpers.rails_blob_url(img, only_path: true)
      else
        re = img&.service_url&.split("?")&.first
      end
    end
    re
  end

  def to_json
    {
        name: @deck.name,
        cards: @deck.cards.map do |card|
          {
              front_image: image_url(card.front_image),
              back_image: image_url(card.back_image),
              front: card.front,
              back: card.back
          }
        end
    }.to_json
  end
end
