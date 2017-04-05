class CreateEventAndOccurrence < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.integer :batch_size
      t.integer :points_per_batch
    end
    create_table :occurrences do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :points
      t.timestamps
    end
    add_column :users, :points, :integer, default: 0
  end
end
