class AddStatsToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :stats, :string
    add_column :teams, :stats, :string
  end
end
