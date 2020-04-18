class AddSolutionTypeToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :solution_type, :integer, default: 0
  end
end
