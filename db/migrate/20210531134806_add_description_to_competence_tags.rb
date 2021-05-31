class AddDescriptionToCompetenceTags < ActiveRecord::Migration[5.2]
  def change
    add_column :competence_tags, :description, :string
  end
end
