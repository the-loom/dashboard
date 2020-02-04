class CreateTinyCardsModels < ActiveRecord::Migration[5.2]
  def change
    create_table :tiny_cards_decks do |t|
      t.string :name

      t.timestamps
    end

    create_table :courses_tiny_cards_decks do |t|
      t.integer :course_id
      t.integer :deck_id
    end

    create_table :tiny_cards_cards do |t|
      t.string :front
      t.string :back

      t.integer :tiny_cards_deck_id
      t.integer :author_id
      t.timestamps
    end
  end
end
