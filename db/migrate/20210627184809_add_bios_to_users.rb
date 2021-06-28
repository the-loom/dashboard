class AddBiosToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bios, :string
  end
end
