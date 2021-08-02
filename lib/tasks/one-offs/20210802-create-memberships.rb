# Script for AyP1

ActiveRecord::Base.transaction do
  andres = 681
  fabian = 148
  lean = 391
  leo = 2
  lmpl = 288
  lucas = 1
  vale = 183

  profes = [lucas, leo, vale, lean, andres, lmpl, fabian]
  cursos = [47, 48, 49]

  profes.each do |profe_id|
    cursos.each do |curso_id|
      Membership.create(course_id: curso_id, user_id: profe_id, enabled: true, role: :teacher)
    end
  end
end
