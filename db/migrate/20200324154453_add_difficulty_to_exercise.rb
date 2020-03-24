class AddDifficultyToExercise < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :difficulty, :integer
  end
end
