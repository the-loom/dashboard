class CreateIdentityForUser < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :image

      t.references :user
      t.timestamps
    end

    remove_column :users, :provider
    remove_column :users, :uid
  end
end
