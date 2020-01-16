class AddStatsToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :stats, :string
  end
end
