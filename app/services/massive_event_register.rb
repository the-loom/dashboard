class MassiveEventRegister
  def initialize(students, event, multiplier)
    @students = students
    @event = event
    @multiplier = multiplier
  end

  def execute
    @multiplier.times do
      @students.each do |student|
        student.register(@event)
      end
    end

    true
  end
end
