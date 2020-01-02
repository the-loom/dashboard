class RemoveSlugFromBadge < ActiveRecord::Migration[5.2]
  def change
    remove_column :badges, :slug
  end
end
