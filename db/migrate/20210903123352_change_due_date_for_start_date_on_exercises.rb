class ChangeDueDateForStartDateOnExercises < ActiveRecord::Migration[5.2]
  def change
    rename_column :exercises, :due_date, :start_date
  end
end
