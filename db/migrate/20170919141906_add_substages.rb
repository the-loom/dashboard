class AddSubstages < ActiveRecord::Migration[5.0]
  def change
    add_column :timers, :description, :string, default: nil
  end
end
