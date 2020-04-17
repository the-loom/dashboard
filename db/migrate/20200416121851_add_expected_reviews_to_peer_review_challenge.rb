class AddExpectedReviewsToPeerReviewChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :expected_reviews, :integer, default: 1
  end
end
