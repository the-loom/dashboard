class AddTeamToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :team_id, :integer

    execute "update memberships set team_id = (select team_id from users where id = memberships.user_id);"

    remove_column :users, :team_id
  end
end
