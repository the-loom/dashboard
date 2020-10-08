class AddHiddenToMultipleChoiceQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :multiple_choices_questions, :hidden, :boolean, default: false
  end
end
