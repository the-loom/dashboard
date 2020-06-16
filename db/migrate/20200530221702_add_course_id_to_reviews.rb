class AddCourseIdToReviews < ActiveRecord::Migration[5.2]
  def up
    add_column :peer_review_reviews, :course_id, :integer

    execute <<-SQL
    update peer_review_reviews
    set course_id = sq.course_id
    from (select s.id as id, course_id from peer_review_challenges c inner join peer_review_solutions s on s.peer_review_challenge_id = c.id) as sq
    where peer_review_reviews.peer_review_solution_id = sq.id
    SQL
  end

  def down
    remove_column :peer_review_reviews, :course_id
  end
end
