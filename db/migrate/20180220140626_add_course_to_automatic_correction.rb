class AddCourseToAutomaticCorrection < ActiveRecord::Migration[5.0]
  def change
    add_column :automatic_correction_repos, :course_id, :integer
    add_column :automatic_correction_test_runs, :course_id, :integer
    add_column :automatic_correction_results, :course_id, :integer
    add_column :automatic_correction_issues, :course_id, :integer
  end
end
