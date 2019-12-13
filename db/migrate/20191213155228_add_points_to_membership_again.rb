class AddPointsToMembershipAgain < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :points, :integer, default: 0
  end
end
