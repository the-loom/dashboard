class ChangeDefaultPublishedToChallenge < ActiveRecord::Migration[5.2]
  def change
    change_column_default :peer_review_challenges, :published, from: true, to: false
  end
end
