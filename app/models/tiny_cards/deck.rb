class TinyCards::Deck < ApplicationRecord
  include Publishable

  has_many :cards, foreign_key: :tiny_cards_deck_id, dependent: :destroy
  # TODO: needed?
  has_and_belongs_to_many :courses

  validates_presence_of :name
end
