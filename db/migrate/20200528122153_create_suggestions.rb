class CreateSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestions do |t|
      t.string :title
      t.text :body
      t.integer :suggestion_type
      t.integer :course_id
      t.integer :author_id
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
