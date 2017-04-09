class CreateBadge < ActiveRecord::Migration[5.0]
  def change
    create_table :badges do |t|
      t.string :name
      t.string :description
      t.string :slug
    end
    create_table :earnings do |t|
      t.integer :user_id
      t.integer :badge_id
      t.timestamps
    end
  end
end
