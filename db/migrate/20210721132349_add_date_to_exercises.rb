class AddDateToExercises < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :due_date, :date
  end
end
