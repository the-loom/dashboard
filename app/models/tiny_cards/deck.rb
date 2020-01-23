class TinyCards::Deck < ApplicationRecord
  has_many :cards, foreign_key: :tiny_cards_deck_id
  has_and_belongs_to_many :courses

  validates_presence_of :name
end
