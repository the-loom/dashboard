class AddMultiplierToOccurrences < ActiveRecord::Migration[5.2]
  def change
    add_column :occurrences, :multiplier, :integer, default: 1
  end
end
