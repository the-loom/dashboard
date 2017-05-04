class AddSecondaryImageToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :secondary_image, :string
  end
end
