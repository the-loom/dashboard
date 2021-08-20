require "csv"

course_ids = 35..46

CSV.open("./report.csv", "w") do |csv|
  Course.where(id: course_ids).order(name: :asc).each do |course|
    Course.current = course
    students = course.students.order(last_name: :asc)
    lectures = Lecture.past_and_current

    csv << [course.name]
    csv << ["Estudiante"] + lectures.map(&:summary) + ["Presentes totales"]

    students.each do |student|
      student_attendance_summary = [student.full_name]
      total_attendance = 0
      lectures.each do |lecture|
        student_attendance_summary << (student.present_at(lecture) ? "P" : "A")
        total_attendance += 1 if student.present_at(lecture)
      end
      csv << student_attendance_summary + [total_attendance]
    end
  end
end
