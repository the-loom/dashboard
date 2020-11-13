class AddEnabledToQuestionnaire < ActiveRecord::Migration[5.2]
  def change
    add_column :multiple_choices_questionnaires, :enabled, :boolean, default: false
  end
end
