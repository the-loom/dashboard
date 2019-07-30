class MassiveTeacherPromoter
  def initialize(students)
    @students = students
  end

  def execute
    @students.each do |student|
      student.current_membership.update(role: :teacher)
    end

    true
  end
end
