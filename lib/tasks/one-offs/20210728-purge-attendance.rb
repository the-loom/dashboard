ActiveRecord::Base.transaction do
  Course.where(id: 35..46).each do |course|
    Course.current = course
    valid_lecture_ids = Lecture.all.map(&:id)
    course.students.each do |student|
      mem = student.current_membership(course)
      mem.present_at_lecture_ids = mem.present_at_lecture_ids & valid_lecture_ids
      mem.save!
    end
    Course.current = nil
  end
end
