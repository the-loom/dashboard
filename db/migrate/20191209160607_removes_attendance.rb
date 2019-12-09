class RemovesAttendance < ActiveRecord::Migration[5.2]
  def change
    drop_table :attendances
  end
end
