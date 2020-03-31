class AddAllowsAttachmentToPeerReviewChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :allows_attachment, :boolean, default: false
  end
end
