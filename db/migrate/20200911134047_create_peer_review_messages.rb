class CreatePeerReviewMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :peer_review_messages do |t|
      t.text :content
      # context
      t.integer :peer_review_review_id
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end
  end
end
