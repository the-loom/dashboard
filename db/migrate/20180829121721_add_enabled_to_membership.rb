class AddEnabledToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :enabled, :boolean, default: true

    execute "update memberships set enabled = 0 where user_id in (select id from users where enabled = 0);"

    remove_column :users, :enabled
  end
end
