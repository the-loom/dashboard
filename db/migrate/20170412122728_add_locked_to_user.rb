class AddLockedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :locked, :boolean, default: false
  end
end
