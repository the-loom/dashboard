class AddTeamChallengeToPeerReviewChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :team_challenge, :boolean, default: false
  end
end
