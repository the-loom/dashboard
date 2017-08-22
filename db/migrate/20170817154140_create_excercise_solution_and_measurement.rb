class CreateExcerciseSolutionAndMeasurement < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :url
      t.text :notes
    end
    create_table :solutions do |t|
      t.integer :exercise_id
      t.integer :user_id
      t.datetime :finished_at
      t.text :notes
      t.timestamps
    end
    create_table :exercise_timers do |t|
      t.integer :solution_id
      t.integer :stage
      t.string :sub_stage
      t.integer :total_time_in_milliseconds
      t.integer :estimated_time_in_milliseconds
      t.datetime :started_at
    end
  end
end
