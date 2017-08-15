class CreateTagForUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :name
    end
    create_table :user_tags do |t|
      t.integer :user_id
      t.integer :tag_id
    end
  end
end
