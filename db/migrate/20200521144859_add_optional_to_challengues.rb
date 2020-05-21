class AddOptionalToChallengues < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :optional, :boolean, default: false
  end
end
