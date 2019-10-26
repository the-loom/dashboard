class AddEnabledToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :enabled, :boolean, default: true
  end
end
