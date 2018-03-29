class AddDetailsToAutomaticCorrectionTestRuns < ActiveRecord::Migration[5.0]
  def change
    add_column :automatic_correction_test_runs, :details, :text
  end
end
