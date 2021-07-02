class AddStartAndEndTimeForLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :time_from, :time, default: nil
    add_column :lectures, :time_to, :time, default: nil
  end
end
