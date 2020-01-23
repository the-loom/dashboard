class TinyCards::Card < ApplicationRecord
  belongs_to :deck, foreign_key: :tiny_cards_deck_id
end
