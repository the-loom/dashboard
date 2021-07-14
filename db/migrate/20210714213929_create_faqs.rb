class CreateFaqs < ActiveRecord::Migration[5.2]
  def change
    create_table :faqs do |t|
      t.string :question
      t.text :answer

      t.integer :course_id
      t.timestamps
    end
  end
end
