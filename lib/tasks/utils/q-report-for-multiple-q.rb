require "csv"

course_ids = 48..49

CSV.open("./questionnaires.csv", "w") do |csv|
  Course.where(id: course_ids).order(name: :asc).each do |course|
    Course.current = course
    students = course.students.order(last_name: :asc)
    questionnaires = MultipleChoices::Questionnaire.all.order(name: :asc)

    csv << [course.name]

    header = ["ID", "Estudiante"]
    questionnaires.each do |q|
      header << q.name
    end
    header << "Condición"

    csv << header
    students.each do |student|
      summary = [student.id, student.full_name]
      total = 0
      questionnaires.each do |q|
        summary << q.solved_by?(student)
        total += 1 if q.solved_by?(student)
      end
      summary << total

      csv << summary
    end
  end
end
