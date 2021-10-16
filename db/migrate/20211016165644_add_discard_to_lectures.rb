class AddDiscardToLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :discarded_at, :datetime
    add_index :lectures, :discarded_at
  end
end
