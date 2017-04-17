class CreateReading < ActiveRecord::Migration[5.0]
  def change
    create_table :readings do |t|
      t.string :name
      t.string :description
      t.string :slug
    end
    create_table :measurements do |t|
      t.integer :team_id
      t.integer :reading_id
      t.integer :value
      t.timestamps
    end
  end
end
