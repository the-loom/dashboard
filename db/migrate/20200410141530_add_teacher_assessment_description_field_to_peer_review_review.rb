class AddTeacherAssessmentDescriptionFieldToPeerReviewReview < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_reviews, :teacher_assessment_description, :string
  end
end
