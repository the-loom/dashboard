class AddLanguageToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :peer_review_challenges, :language, :string
  end
end
