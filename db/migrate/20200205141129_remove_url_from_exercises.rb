class RemoveUrlFromExercises < ActiveRecord::Migration[5.2]
  def change
    remove_column :exercises, :url
  end
end
