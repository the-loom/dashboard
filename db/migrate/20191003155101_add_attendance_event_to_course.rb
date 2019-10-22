class AddAttendanceEventToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :attendance_event_id, :integer
    remove_column :memberships, :points
  end
end
