class AddAdminRoleToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false
    execute 'update memberships set role = 2 where role = 3'
  end
end
