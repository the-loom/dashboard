class AddSurnameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_name, :string
    rename_column :users, :name, :first_name

    add_column :identities, :last_name, :string
    rename_column :identities, :name, :first_name
  end
end
