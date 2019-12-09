class MassiveAttendanceRegister
  def initialize(students, lecture)
    @students = students
    @lecture = lecture
  end

  def execute
    @students.each do |student|
      student.register_attendance(@lecture)
    end

    true
  end
end
