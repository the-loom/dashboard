class AddRequiredToLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :required, :boolean, default: true
  end
end
