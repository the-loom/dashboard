class AddRegitrableToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :registrable, :boolean, default: true
  end
end
