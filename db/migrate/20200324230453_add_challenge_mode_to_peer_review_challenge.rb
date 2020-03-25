class AddChallengeModeToPeerReviewChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :challenge_mode, :integer, default: 0
  end
end
