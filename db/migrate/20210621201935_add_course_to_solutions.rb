class AddCourseToSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_solutions, :course_id, :integer

    execute "update peer_review_solutions s set course_id = (select c.course_id from peer_review_challenges c where c.id = s.peer_review_challenge_id)"
  end
end
