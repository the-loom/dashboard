class RemoveSolutions < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_solutions
    drop_table :timers
    drop_table :solutions
  end
end
