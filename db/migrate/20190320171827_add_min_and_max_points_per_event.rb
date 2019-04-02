class AddMinAndMaxPointsPerEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :min_points, :integer
    add_column :events, :max_points, :integer
    rename_column :events, :points_per_batch, :points
    remove_column :events, :batch_size
  end
end
