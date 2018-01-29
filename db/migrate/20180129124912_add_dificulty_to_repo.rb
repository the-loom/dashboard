class AddDificultyToRepo < ActiveRecord::Migration[5.0]
  def change
    add_column :automatic_correction_repos, :dificulty, :integer
  end
end
