class RemoveTeacherAssessment < ActiveRecord::Migration[5.2]
  def change
    remove_column :peer_review_reviews, :teacher_assessment
    remove_column :peer_review_reviews, :assessor_id
    remove_column :peer_review_reviews, :teacher_assessment_description
  end
end
