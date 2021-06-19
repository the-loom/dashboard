class CreatePost < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :text
      t.boolean :pinned, default: false

      t.references :author, index: true, foreign_key: { to_table: :users }
      t.references :notification

      t.references :course
      t.timestamps
    end
  end
end
