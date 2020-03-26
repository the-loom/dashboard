class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_categories do |t|
      t.string :name

      t.integer :course_id
      t.timestamps
    end

    create_table :resources do |t|
      t.string :url
      t.string :title
      t.string :description

      t.integer :resource_category_id
      t.integer :course_id
      t.timestamps
    end
  end
end
