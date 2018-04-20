class AddUuidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :uuid, :string

    User.all.each do |user|
      user.update_attributes(uuid: (user.id + 272).to_s(16).upcase)
    end

  end
end
