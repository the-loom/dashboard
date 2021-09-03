class AddStartDateToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :start_date, :date
  end
end
