class AddDiscardedAtToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :discarded_at, :datetime
    add_index :memberships, :discarded_at
  end
end
