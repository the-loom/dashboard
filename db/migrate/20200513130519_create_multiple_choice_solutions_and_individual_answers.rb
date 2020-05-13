class CreateMultipleChoiceSolutionsAndIndividualAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :multiple_choices_solutions do |t|
      t.integer :course_id
      t.integer :multiple_choices_questionnaire_id
      t.integer :user_id
      t.decimal :score, precision: 5, scale: 2

      t.timestamps
    end

    create_table :multiple_choices_responses do |t|
      t.integer :multiple_choices_solution_id
      t.integer :multiple_choices_question_id
      t.integer :multiple_choices_answer_id

      t.boolean :correct, default: false
    end
  end
end
