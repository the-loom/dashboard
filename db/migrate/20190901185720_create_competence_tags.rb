class CreateCompetenceTags < ActiveRecord::Migration[5.2]
  def change
    create_table :competence_tags do |t|
      t.string :name

      t.integer :course_id
      t.timestamps
    end

    add_column :events, :competence_tag_id, :integer
  end
end
