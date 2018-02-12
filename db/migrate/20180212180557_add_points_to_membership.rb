class AddPointsToMembership < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :points
    add_column :memberships, :points, :integer, default: 0
  end
end
