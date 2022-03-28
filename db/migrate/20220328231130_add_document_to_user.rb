class AddDocumentToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :alternative_id, :string
  end
end
