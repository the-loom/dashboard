class CreateComment < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :body, limit: 65535
      t.integer :mood, default: 0
      t.integer :user_id
      t.integer :commenter_id
      t.timestamps
    end
  end
end
