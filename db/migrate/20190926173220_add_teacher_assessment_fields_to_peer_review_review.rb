class AddTeacherAssessmentFieldsToPeerReviewReview < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_reviews, :teacher_assessment, :integer, default: 0
    add_column :peer_review_reviews, :assessor_id, :integer
  end
end
