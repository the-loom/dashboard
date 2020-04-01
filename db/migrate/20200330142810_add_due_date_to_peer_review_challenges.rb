class AddDueDateToPeerReviewChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :due_date, :date
  end
end
