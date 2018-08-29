class AddEnabledToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :enabled, :boolean, default: true

    execute "update memberships set enabled = false where user_id in (select id from users where enabled = false);"

    remove_column :users, :enabled
  end
end