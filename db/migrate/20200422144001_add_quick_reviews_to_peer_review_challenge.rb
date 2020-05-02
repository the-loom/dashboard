class AddQuickReviewsToPeerReviewChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :allows_quick_reviews, :boolean, default: false
  end
end
