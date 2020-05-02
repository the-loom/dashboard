class AddLastCourseVisitedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_visited_course_id, :integer, default: 0
  end
end
