class TinyCards::Card < ApplicationRecord
  belongs_to :deck, foreign_key: :tiny_cards_deck_id
  belongs_to :author, foreign_key: :author_id, class_name: "User"
end
