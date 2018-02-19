class RemoveDeadFeatures < ActiveRecord::Migration[5.0]
  def change
    # Removemos Tags
    drop_table :user_tags
    drop_table :tags

    # Removemos Mediciones
    drop_table :measurements
    drop_table :readings

    # Removemos Entregas
    drop_table :checks
    drop_table :checkpoints

    # Removemos imagen secundaria
    remove_column :users, :secondary_image
  end
end
