class MassiveEventRegister
  def initialize(students, event)
    @students = students
    @event = event
  end

  def execute
    @students.each do |student|
      student.register(@event)
    end

    true
  end
end
