class AddPasswordToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :password, :string
  end
end
