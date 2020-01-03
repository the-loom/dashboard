class AddPointsToTeam < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :points, :integer, default: 0
  end
end
