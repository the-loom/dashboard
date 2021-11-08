class CreateCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :certificates do |t|
      t.string :name
      t.string :code

      t.references :user
      t.timestamps
    end
  end
end
