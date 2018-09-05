class AddEnabledToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :enabled, :boolean, default: true
  end
end
