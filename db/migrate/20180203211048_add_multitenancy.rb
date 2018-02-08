class AddMultitenancy < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.timestamps
    end

    create_table :memberships do |t|
      t.integer :course_id
      t.integer :user_id
      t.integer :role
      t.timestamps
    end

    add_column :attendances, :course_id, :integer
    add_column :badges, :course_id, :integer
    add_column :checkpoints, :course_id, :integer
    add_column :checks, :course_id, :integer
    add_column :comments, :course_id, :integer
    add_column :earnings, :course_id, :integer
    add_column :events, :course_id, :integer
    add_column :exercises, :course_id, :integer
    add_column :lectures, :course_id, :integer
    add_column :measurements, :course_id, :integer
    add_column :occurrences, :course_id, :integer
    add_column :readings, :course_id, :integer
    add_column :solutions, :course_id, :integer
    add_column :teams, :course_id, :integer
    add_column :timers, :course_id, :integer
    add_column :user_solutions, :course_id, :integer

    remove_column :users, :role
  end
end
