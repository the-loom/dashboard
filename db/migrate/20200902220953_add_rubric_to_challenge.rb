class AddRubricToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :rubrics, :string
    add_column :peer_review_reviews, :rubrics, :string
  end
end
