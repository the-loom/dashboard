class CreatePeerReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :peer_review_challenges do |t|
      t.string :title
      t.integer :difficulty
      t.string :instructions
      t.string :reviewer_instructions

      t.integer :course_id
      t.timestamps
    end

    create_table :peer_review_solutions do |t|
      t.string :wording
      t.integer :status

      t.integer :peer_review_challenge_id
      t.integer :author_id
      t.timestamps
    end

    create_table :peer_review_reviews do |t|
      t.string :wording
      t.integer :status

      t.integer :peer_review_solution_id
      t.integer :reviewer_id
      t.timestamps
    end
  end
end
