class RemoveMoodFromComment < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :mood
  end
end
