class AddSingleUseToMultipleChoiceQuestionnaire < ActiveRecord::Migration[5.2]
  def change
    add_column :multiple_choices_questionnaires, :single_use, :boolean, default: false
  end
end
