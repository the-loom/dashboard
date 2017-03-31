class AddTimestampsToUser < ActiveRecord::Migration[5.0]
  def change_table
    add_column(:users, :created_at, :datetime)
    add_column(:users, :updated_at, :datetime)
  end
end
