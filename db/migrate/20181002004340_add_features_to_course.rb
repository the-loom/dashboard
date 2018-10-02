class AddFeaturesToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :features, :integer, default: 0
  end
end
