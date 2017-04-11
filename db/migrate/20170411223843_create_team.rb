class CreateTeam < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :nickname
      t.string :image
    end
    add_column :users, :team_id, :integer
  end
end
