class CreateNotification < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :subject
      t.text :text
      t.string :author

      t.references :course
      t.timestamps
    end

    add_column :memberships, :unread_notifications, :integer, default: 0
  end
end
