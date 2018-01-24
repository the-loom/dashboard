class CreateAutomaticCorrectionEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :automatic_correction_repos do |t|
      t.string :user
      t.string :name
      t.string :git_url
      t.string :avatar_url
      t.string :description
      t.integer :parent_id
      t.timestamps
    end
    add_foreign_key :automatic_correction_repos, :automatic_correction_repos, column: :parent_id

    create_table :automatic_correction_test_runs do |t|
      t.decimal :score, precision: 4, scale: 2
      t.references :automatic_correction_repo, index: { name: "ac_test_runs_index" }
      t.timestamps
    end

    create_table :automatic_correction_results, force: :cascade do |t|
      t.string :test_type
      t.decimal :score, precision: 4, scale: 2
      t.references :automatic_correction_test_run, index: { name: "ac_results_index" }
    end

    create_table :automatic_correction_issues do |t|
      t.string :issue_type
      t.string :message
      t.string :details
      t.string :payload
      t.references :automatic_correction_result, index: { name: "ac_issues_index" }
    end
  end
end
