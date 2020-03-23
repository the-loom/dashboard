class RenameDifficultyToExercise < ActiveRecord::Migration[5.2]
  def change
    rename_column :exercises, :dificulty, :difficulty
  end
end
