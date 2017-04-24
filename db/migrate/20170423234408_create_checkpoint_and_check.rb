class CreateCheckpointAndCheck < ActiveRecord::Migration[5.0]
  def change
    create_table :checkpoints do |t|
      t.string :name
      t.string :link
      t.date :due_date
    end
    create_table :checks do |t|
      t.integer :team_id
      t.integer :checkpoint_id
      t.text :comments, limit: 65535
      t.integer :condition
      t.timestamps
    end
  end
end
