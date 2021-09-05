class AddDiscardedAtToExercises < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :discarded_at, :datetime
    add_index :exercises, :discarded_at
  end
end
