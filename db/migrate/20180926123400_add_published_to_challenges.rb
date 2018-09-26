class AddPublishedToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :published, :boolean, default: true
    add_column :exercises, :published, :boolean, default: true
    add_column :automatic_correction_repos, :published, :boolean, default: true
  end
end
