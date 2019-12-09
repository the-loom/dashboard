class AddPresentAtToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :present_at_lecture_ids, :string
  end
end
