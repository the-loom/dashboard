class ChangeDificultyForDifficulty < ActiveRecord::Migration[5.0]
  def change
    rename_column :automatic_correction_repos, :dificulty, :difficulty
  end
end
