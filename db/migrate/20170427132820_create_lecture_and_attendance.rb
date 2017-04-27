class CreateLectureAndAttendance < ActiveRecord::Migration[5.0]
  def change
    create_table :lectures do |t|
      t.date :date
      t.string :summary
    end
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :lecture_id
      t.integer :condition
    end
  end
end
