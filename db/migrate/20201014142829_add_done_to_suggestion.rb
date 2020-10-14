class AddDoneToSuggestion < ActiveRecord::Migration[5.2]
  def change
    add_column :suggestions, :done, :boolean, default: false
  end
end
