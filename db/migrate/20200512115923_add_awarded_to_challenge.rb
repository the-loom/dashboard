class AddAwardedToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :awarded, :boolean, default: false
  end
end
