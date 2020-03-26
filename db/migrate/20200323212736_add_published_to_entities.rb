class AddPublishedToEntities < ActiveRecord::Migration[5.2]
  def change
    add_column :multiple_choices_questionnaires, :published, :boolean, default: true
    add_column :tiny_cards_decks, :published, :boolean, default: true
  end
end
