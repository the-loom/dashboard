class AddPickedToPeerReviewSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_solutions, :picked, :boolean, default: false
  end
end
