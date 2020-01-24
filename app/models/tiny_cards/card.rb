class TinyCards::Card < ApplicationRecord
  belongs_to :deck, foreign_key: :tiny_cards_deck_id
  belongs_to :author, foreign_key: :author_id, class_name: "User"

  has_one_attached :front_image
  has_one_attached :back_image

  validates :front_image, size: { less_than: 500.kilobyte }, content_type: [:png, :jpg, :jpeg]
  validates :back_image, size: { less_than: 500.kilobyte }, content_type: [:png, :jpg, :jpeg]
end
