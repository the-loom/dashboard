class CreateMultipleChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :multiple_choices_questions do |t|
      t.string :wording

      t.integer :course_id
      t.timestamps
    end
    create_table :multiple_choices_answers do |t|
      t.string :text
      t.boolean :correct
      t.string :explanation

      t.integer :multiple_choices_question_id
      t.timestamps
    end
  end
end
