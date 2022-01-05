ActiveRecord::Base.transaction do
  Course.enabled.each do |course|
    next if course.template? || course.nil?

    Course.current = course
    valid_lecture_ids = Lecture.kept.map(&:id)
    course.students.each do |student|
      mem = student.current_membership(course)
      mem.present_at_lecture_ids = mem.present_at_lecture_ids & valid_lecture_ids
      mem.save!

      attendance_event = Course.current.attendance_event || Course.current.parent_course && Course.current.parent_course.attendance_event
      if attendance_event
        occurrence = student.occurrences.find_by(event: attendance_event, course: Course.current)
        occurrence.destroy unless occurrence.nil?
        student.register(attendance_event, mem.present_at_lecture_ids.size, Course.current) if mem.present_at_lecture_ids
      end
    end
    Course.current = nil
  end
end
