require "csv"

course_ids = 48..49

CSV.open("./challenges.csv", "w") do |csv|
  Course.where(id: course_ids).order(name: :asc).each do |course|
    Course.current = course
    students = course.students.order(last_name: :asc)
    challenges = PeerReview::Challenge.where("title like 'Tarea%'").order(due_date: :asc).compact

    csv << [course.name]

    header = ["ID", "Estudiante"]
    challenges.each do |ch|
      header << ch.title
      header << "Prome"
      header << "Revisó"
      header << "URL"
    end
    header << "Condición"

    csv << header
    students.each do |student|
      summary = [student.id, student.full_name]
      total = 0
      challenges.each do |challenge|
        solution = challenge.solution_by(student)
        tmp = []
        reviewer = "-"
        if solution
          review = solution.reviews.last
          if review
            review.rubrics.map do |_, sc|
              tmp << sc
            end
            reviewer = review.reviewer.full_name
          end
        else
          tmp = [0]
        end
        summary << "{ " + tmp.join(", ") + " }"
        avg = tmp.reduce(:+).to_f / tmp.size
        summary << avg
        summary << reviewer
        summary << (solution.nil? ? "-" : "https://loom.wecode.io/peer_review/challenges/#{challenge.id}/solutions/#{solution.id}")
        total += 1 if avg > 1.0
      end
      summary << total

      csv << summary
    end
  end
end
