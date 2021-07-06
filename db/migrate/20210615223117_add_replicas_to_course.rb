class AddReplicasToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :parent_course_id, :integer
    add_foreign_key :courses, :courses, column: :parent_course_id
    add_column :courses, :replica, :boolean, default: false
  end
end
